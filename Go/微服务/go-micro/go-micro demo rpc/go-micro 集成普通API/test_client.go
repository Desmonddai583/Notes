package main

import (
	"context"
	"fmt"

	"github.com/go-acme/lego/v3/log"
	"github.com/micro/go-micro/client"
	"github.com/micro/go-micro/client/selector"
	"github.com/micro/go-micro/registry"
	"github.com/micro/go-micro/registry/etcd"
	myHttp "github.com/micro/go-plugins/client/http"
)

func main() {
	etcdReg := etcd.NewRegistry(registry.Addrs("192.168.29.135:23791"))

	mySelector := selector.NewSelector(
		selector.Registry(etcdReg),
		selector.SetStrategy(selector.RoundRobin))
	getClient := myHttp.NewClient(client.Selector(mySelector), client.ContentType("application/json"))

	//1、创建request
	req := getClient.NewRequest("api.jtthink.com.test", "/v1/test", map[string]string{})
	//2、创建response
	var rsp map[string]interface{}
	err := getClient.Call(context.Background(), req, &rsp)
	if err != nil {
		log.Fatal(err)
	}
	fmt.Println(rsp)
}
