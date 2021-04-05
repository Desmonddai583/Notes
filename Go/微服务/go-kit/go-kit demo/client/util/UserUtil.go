package util

import (
	"context"
	"io"
	"net/url"
	"os"
	"time"

	"github.com/go-kit/kit/endpoint"
	"github.com/go-kit/kit/log"
	"github.com/go-kit/kit/sd"
	"github.com/go-kit/kit/sd/consul"
	"github.com/go-kit/kit/sd/lb"
	httptransport "github.com/go-kit/kit/transport/http"
	consulapi "github.com/hashicorp/consul/api"
	. "product.jtthink.com/Services"
)

func GetUser() (string, error) {
	{
		//第一步：创建client
		config := consulapi.DefaultConfig()
		config.Address = "192.168.29.128:8500" //注册中心的地址
		api_client, err := consulapi.NewClient(config)
		if err != nil {
			return "", err
		}
		client := consul.NewClient(api_client)
		var logger log.Logger
		{
			logger = log.NewLogfmtLogger(os.Stdout)
		}
		{
			tags := []string{"primary"}
			//可实时查询服务实例的状态信息
			instancer := consul.NewInstancer(client, logger, "userservice", tags, true)
			{
				factory := func(service_url string) (endpoint.Endpoint, io.Closer, error) {
					tart, _ := url.Parse("http://" + service_url) //192.168.29.1:8080 真实服务端的地址
					return httptransport.NewClient("GET", tart, GetUserInfo_Request, GetUserInfo_Response).Endpoint(), nil, nil
				}
				endpointer := sd.NewEndpointer(instancer, factory, logger)
				mylb := lb.NewRandom(endpointer, time.Now().UnixNano())

				getUserInfo, err := mylb.Endpoint()
				if err != nil {
					return "", err
				}
				ctx := context.Background() //第三步：创建一个context上下文对象

				//第四步：执行
				res, err := getUserInfo(ctx, UserRequest{Uid: 102})
				if err != nil {
					return "", err
				}
				//第五步：断言，得到响应值
				userinfo := res.(UserResponse)
				return userinfo.Result, nil

			}
		}

	}
}
