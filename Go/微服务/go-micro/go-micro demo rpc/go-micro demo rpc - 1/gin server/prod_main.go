package main

import (
	"context"
	"fmt"

	"github.com/micro/go-micro"
	"github.com/micro/go-micro/client"
	"github.com/micro/go-micro/metadata"
	"github.com/micro/go-micro/registry"
	"github.com/micro/go-micro/registry/consul"
	"github.com/micro/go-micro/web"
	"gomicro.jtthink.com/Services"
	"gomicro.jtthink.com/Weblib"
	"gomicro.jtthink.com/Wrappers"
)

type logWrapper struct {
	client.Client
}

func (this *logWrapper) Call(ctx context.Context, req client.Request, rsp interface{}, opts ...client.CallOption) error {
	md, _ := metadata.FromContext(ctx)
	fmt.Printf("[Log Wrapper] ctx: %v service: %s method: %s\n", md, req.Service(), req.Endpoint())
	return this.Client.Call(ctx, req, rsp)
}
func NewLogWrapper(c client.Client) client.Client {
	return &logWrapper{c}
}
func main() {
	consulReg := consul.NewRegistry(
		registry.Addrs("192.168.29.135:8500"),
	)
	myService := micro.NewService(
		micro.Name("prodservice.client"),
		micro.WrapClient(NewLogWrapper),
		micro.WrapClient(Wrappers.NewProdsWrapper),
	)
	prodService := Services.NewProdService("prodservice", myService.Client())

	httpServer := web.NewService(
		web.Name("httpprodservice"),
		web.Address(":8001"),
		web.Handler(Weblib.NewGinRouter(prodService)),
		web.Registry(consulReg),
	)

	httpServer.Init()
	httpServer.Run()

}
