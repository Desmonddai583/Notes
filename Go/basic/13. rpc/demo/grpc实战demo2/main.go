package main

import (
	"log"
	"mygrpc/src/pbfiles"
	"mygrpc/src/services"
	"net"

	"google.golang.org/grpc"
)

func main() {

	myserver := grpc.NewServer()
	pbfiles.RegisterProdServiceServer(myserver, services.NewProdService())
	//监听8080
	lis, _ := net.Listen("tcp", ":8080")
	if err := myserver.Serve(lis); err != nil {
		log.Fatal(err)
	}

}
