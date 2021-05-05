package main

import (
	"eventbus/services"
	"google.golang.org/grpc"
	"log"
	"net"
)
func checkError(e error){
	if e!=nil{
		panic(e.Error())
	}
}
func main() {
	server:=grpc.NewServer()
	services.RegisterUserServiceServer(server,&services.UserService{})
	lis,_:=net.Listen("tcp",":8080")
	if err:=server.Serve(lis);err!=nil {
		log.Fatal(err)
	}

}