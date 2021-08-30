package main

import (
	"google.golang.org/grpc"
	"log"
	"mygrpc/pbfiles"
	"mygrpc/serviceimpl"

	"net"
)
func main() {

    myserver:=grpc.NewServer()
     pbfiles.RegisterProdServiceServer(myserver,serviceimpl.NewProdServiceImpl())
	lis,_:=net.Listen("tcp",":8080")
	if err:=myserver.Serve(lis);err!=nil {
		log.Fatal(err)
	}
}