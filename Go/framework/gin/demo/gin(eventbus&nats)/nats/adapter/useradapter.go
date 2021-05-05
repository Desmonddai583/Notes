package main

import (
	"context"
	"eventbus/services"
	"github.com/gin-gonic/gin"
	"github.com/nats-io/nats.go"
	"google.golang.org/grpc"
	"log"
	"strconv"
)
//用户信息相关
var userInfoClient *grpc.ClientConn
var scoreClient *grpc.ClientConn
func initClient(address string ) *grpc.ClientConn{
	client,err:=grpc.Dial(address,grpc.WithInsecure())
	if err!=nil{
		log.Fatal(err)
	}
	return client
}
func init() {
	userInfoClient=initClient("localhost:8080")
	scoreClient=initClient("localhost:8081")
}
func main(){
	services.InitJSONBroker()
	_,err:=services.Broker.Subscribe("users.get.info", func(msg *nats.Msg) {
			go func() {
				 id:=string(msg.Data)
				 intid,_:=strconv.Atoi(id)
				//去调用 grpc server  执行用户API
				info:=services.NewUserServiceClient(userInfoClient)
				ctx:=context.Background()
				userRequest:=&services.UserRequest{UserId:int32(intid)}
				userRsp,_:=info.GetUserInfo(ctx,userRequest)


				//去调用 grpc server  执行Score API
				scoreRequest:=&services.ScoreRequest{UserId:int32(intid)}
				score:=services.NewScoreServiceClient(scoreClient)
				scoreRsp,_:=score.GetScore(ctx,scoreRequest)

				services.JSONBroker.Publish(msg.Reply,gin.H{"user":userRsp.Result,"score":scoreRsp.Score})

			}()
	})
	if err!=nil{
		log.Fatal(err)
	}
	log.Println("启动用户adpter....")
	select{}
}
