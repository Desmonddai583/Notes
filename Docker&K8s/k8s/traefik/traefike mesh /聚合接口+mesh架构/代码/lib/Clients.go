package lib

import (
	"context"
	"google.golang.org/grpc"
	"log"
)

//初始化商品 grpcClient
func InitProdsClient() *grpc.ClientConn{
	client,err:=grpc.DialContext(context.Background(),
		"prodservice.tk.traefik.mesh:80",grpc.WithInsecure())
	if err!=nil{
		log.Fatal(err)
	}
	return client
}