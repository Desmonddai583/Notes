package main

import (
	"context"
	"fmt"
	"log"
	"net/url"
	"os"
	"time"

	"github.com/afex/hystrix-go/hystrix"
	httptransport "github.com/go-kit/kit/transport/http"
	. "product.jtthink.com/Services"
	"product.jtthink.com/util"
)

func main_2() {

	tgt, _ := url.Parse("http://localhost:8080")
	//第一步：创建一个直连client,这里我们必须 写两个func， 一个是"如何请求" 一个是响应我们怎么处理
	client := httptransport.NewClient("GET", tgt, GetUserInfo_Request, GetUserInfo_Response)
	//第二步：暴露出endpoint（这货就是一个func)，以便执行
	getUserInfo := client.Endpoint()

	ctx := context.Background() //第三步：创建一个context上下文对象

	//第四步：执行
	res, err := getUserInfo(ctx, UserRequest{Uid: 101})
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
	//第五步：断言，得到响应值
	userinfo := res.(UserResponse)
	fmt.Println(userinfo.Result)

}

func main() {
	configA := hystrix.CommandConfig{
		Timeout:                2000,
		MaxConcurrentRequests:  5,
		RequestVolumeThreshold: 3,
		ErrorPercentThreshold:  20,
		SleepWindow:            int(time.Second * 100),
	}
	hystrix.ConfigureCommand("getuser", configA)
	err := hystrix.Do("getuser", func() error {
		res, err := util.GetUser()
		fmt.Println(res)
		return err
	}, func(e error) error {
		fmt.Println("降级用户")
		return e
	})
	if err != nil {
		log.Fatal(err)
	}

}
