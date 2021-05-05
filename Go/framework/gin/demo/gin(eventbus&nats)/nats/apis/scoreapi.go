package main

import (
	"google.golang.org/grpc"
	"log"
	"eventbus/services"
	"net"
)

func main()  {

	server:=grpc.NewServer()
	services.RegisterScoreServiceServer(server,&services.ScoreService{})
	lis,_:=net.Listen("tcp",":8081")
	if err:=server.Serve(lis);err!=nil {
		log.Fatal(err)
	}
}