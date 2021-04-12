package main

import (
	"context"
	"fmt"
	"io/ioutil"
	"net/http"

	"github.com/micro/go-micro/client"
	"github.com/micro/go-micro/client/selector"
	"github.com/micro/go-micro/registry"
	"github.com/micro/go-micro/registry/consul"
	myhttp "github.com/micro/go-plugins/client/http"
	"github.com/prometheus/common/log"
	"gomicro.jtthink.com/Models"
)

func callAPI2(s selector.Selector) {
	myClient := myhttp.NewClient(
		client.Selector(s),
		client.ContentType("application/json"),
	)
	req := myClient.NewRequest("prodservice", "/v1/prods",
		Models.ProdsRequest{Size: 6})
	var rsp Models.ProdListResponse
	err := myClient.Call(context.Background(), req, &rsp)
	if err != nil {
		log.Fatal(err)
	}
	fmt.Println(rsp.GetData())
}

//原始调用方式
func callAPI(addr string, path string, method string) (string, error) {
	req, _ := http.NewRequest(method, "http://"+addr+path, nil)
	client := http.DefaultClient
	res, err := client.Do(req)
	if err != nil {
		return "", err
	}
	defer res.Body.Close()
	buf, _ := ioutil.ReadAll(res.Body)
	return string(buf), nil
}

func main() {
	consulReg := consul.NewRegistry(
		registry.Addrs("192.168.29.135:8500"),
	)
	mySelector := selector.NewSelector(
		selector.Registry(consulReg),
		selector.SetStrategy(selector.RoundRobin),
	)
	callAPI2(mySelector)

}
