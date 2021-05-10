package main

import (
	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials"
	"log"
	"mygrpc/src/pbfiles"
	"mygrpc/src/services"
	"net"
)

func main() {
	creds, err := credentials.NewServerTLSFromFile("certs/server.pem",
		"certs/server.key")
	if err != nil {
		log.Fatal(err)
	}

	myserver:=grpc.NewServer(grpc.Creds(creds))
	pbfiles.RegisterProdServiceServer(myserver,services.NewProdService())
	//监听8080
	lis,err:=net.Listen("tcp",":8080")
	if err!=nil{
		log.Fatal(err)
	}

	if err:=myserver.Serve(lis);err!=nil {
		log.Fatal(err)
	}

}