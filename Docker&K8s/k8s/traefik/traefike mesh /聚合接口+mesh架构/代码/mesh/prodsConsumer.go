package main

import (
	"context"
	"log"
	"mygrpc/lib"
	"mygrpc/pbfiles"

	"github.com/golang/protobuf/proto"
	"github.com/nats-io/nats.go"
)

func checkRpcError(e error) {
	if e != nil {
		panic(e)
	}
}

var defaultProds = []*pbfiles.ProdModel{
	{Id: 1200, Name: "默认商品"},
	{Id: 1300, Name: "热门商品"},
}

func main() {
	lib.InitBroker()
	_, err := lib.Broker.Subscribe("prods.get.hot", func(msg *nats.Msg) {
		prodsClient := lib.InitProdsClient()
		go func() {
			req := new(pbfiles.HotProdRequest)
			rsp := new(pbfiles.HotProdResponse)
			defer func() {
				if e := recover(); e != nil {
					log.Println(e)
					rsp.Result = defaultProds //服务降级
					rspBytes, _ := proto.Marshal(rsp)
					err := lib.Broker.Publish(msg.Reply, rspBytes)
					if err != nil {
						log.Println(err)
					}
				}
			}()
			checkRpcError(proto.Unmarshal(msg.Data, req)) //反序列化请求参数
			checkRpcError(prodsClient.Invoke(context.Background(),
				"/ProdService/GetHotProds", req, rsp))

			rspBytes, _ := proto.Marshal(rsp)
			_ = lib.Broker.Publish(msg.Reply, rspBytes) //回传消息

		}()
	})
	if err != nil {
		log.Fatal(err)
	}
	log.Println("启动prods消费者....")
	select {}
}
