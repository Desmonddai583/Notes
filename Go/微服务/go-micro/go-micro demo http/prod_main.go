package main

import (
	"github.com/gin-gonic/gin"
	"github.com/micro/go-micro/registry"
	"github.com/micro/go-micro/registry/consul"
	"github.com/micro/go-micro/web"
	"gomicro.jtthink.com/Helper"
	"gomicro.jtthink.com/ProdService"
)

func main() {
	consulReg := consul.NewRegistry(
		registry.Addrs("192.168.29.135:8500"),
	)
	ginRouter := gin.Default()
	server := web.NewService(
		web.Name("prodservice"),
		//web.Address(":8001"),
		web.Handler(ginRouter),
		web.Registry(consulReg),
	)
	v1Group := ginRouter.Group("/v1")
	{
		v1Group.Handle("POST", "/prods", func(context *gin.Context) {
			var pr Helper.ProdsRequest
			err := context.Bind(&pr)
			if err != nil || pr.Size <= 0 {
				pr = Helper.ProdsRequest{Size: 2}
			}
			context.JSON(200,
				gin.H{
					"data": ProdService.NewProdList(pr.Size)})
		})

	}
	server.Init()
	server.Run()

}
