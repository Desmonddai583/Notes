package main

import (
	"log"
	"mygrpc/pbfiles"
	"mygrpc/serviceimpl"

	"google.golang.org/grpc"

	"net"
)

func main() {

	myserver := grpc.NewServer()
	pbfiles.RegisterProdServiceServer(myserver, serviceimpl.NewProdServiceImpl())
	lis, _ := net.Listen("tcp", ":8080")
	if err := myserver.Serve(lis); err != nil {
		log.Fatal(err)
	}
}
