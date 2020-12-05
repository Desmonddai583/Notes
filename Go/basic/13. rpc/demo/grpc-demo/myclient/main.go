package main

import (
	"google.golang.org/grpc"
	"fmt"
	"com.jtthink.net/pbfiles"
	"context"
)

func main() {
	//client, eror := rpc.Dial("tcp", "127.0.0.1:8082")
	//if eror != nil {
	//	fmt.Println(eror)
	//	return
	//}
  //
  //ret:=prod.ProdResponse{}
  //err:=client.Call("ProdService.GetStock", prod.ProdRequest{ProdId:600},&ret)
  //if err!=nil{
  //	fmt.Println(err)
  //	return
  //}
  //fmt.Println(ret.ProdStock)

		conn,err:=grpc.Dial("127.0.0.1:8082",grpc.WithInsecure())
		if err!=nil{
			fmt.Println(err)
			return
		}
		defer  conn.Close()


		client:=prod.NewProdServiceClient(conn)
		ret,err:=client.GetProdStock(context.Background(),&prod.ProdRequest{ProdId:600})
		if err!=nil{
			fmt.Println(err)
			return
		}
		fmt.Println(ret.ProdStock)




}