package main

import (
	"github.com/micro/go-micro"
	"github.com/micro/go-micro/registry"
	"github.com/micro/go-micro/registry/consul"
	"github.com/micro/go-micro/service/grpc"
	"tools.jtthink.com/Services"

	"tools.jtthink.com/ServicesImpl"
)

func main() {

	consulReg := consul.NewRegistry(registry.Addrs("192.168.29.135:8500"))

	mySerivce := grpc.NewService(
		micro.Name("api.jtthink.com.test"),
		micro.Address(":8001"),
		micro.Registry(consulReg),
	)

	Services.RegisterTestServiceHandler(mySerivce.Server(), new(ServicesImpl.TestService))
	mySerivce.Run()
}
