package main

import (
	"context"
	"fmt"
	"goetcd/serivces"
	"goetcd/util"
	"log"
)

func main() {
	client := util.NewClient()
	err := client.LoadService()
	if err != nil {
		log.Fatal(err)
	}
	endpoint := client.GetService("productservice", "GET",
		serivces.ProdEncodeFunc)
	if endpoint == nil {
		log.Fatal("没有找到服务")
	}
	res, err := endpoint(context.Background(), serivces.ProdRequest{ProdId: 106})
	if err != nil {
		log.Fatal(err)
	}
	fmt.Println(res)

}
