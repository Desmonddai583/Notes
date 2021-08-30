package main

import (
	"context"
	"fmt"
	"google.golang.org/grpc"
	"log"
	"mygrpc/pbfiles"
)

func main() {
	 //client,err:=grpc.Dial(":8080",grpc.WithInsecure())
	client,err:=grpc.Dial("tk1.jtthink.com:8000",grpc.WithInsecure())
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