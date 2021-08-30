package main

import (
	"context"
	"fmt"
	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials"
	"log"
	"mygrpc/pbfiles"
)

func main() {


	cred,err:=credentials.NewClientTLSFromFile("mycert/wx.jtthink.com_chain.crt","wx.jtthink.com")
	if err!=nil{
		log.Fatal(err)
	}
 	 client,err:=grpc.Dial("wx.jtthink.com:9443",grpc.WithTransportCredentials(cred))
	if err!=nil{
		log.Fatal(err)
	}
	prod:=pbfiles.NewProdServiceClient(client)
	rsp,err:=prod.GetStock(context.Background(),&pbfiles.ProdRequest{})
	if err!=nil{
		log.Fatal(err)
	}
	fmt.Println(rsp.ProdStock)
}