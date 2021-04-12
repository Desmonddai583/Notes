package Weblib

import (
	"context"

	"github.com/gin-gonic/gin"
	"gomicro.jtthink.com/Services"
)

//gin 的方法部分
func GetProdsList(ginCtx *gin.Context) {
	prodService := ginCtx.Keys["prodservice"].(Services.ProdService)
	var prodReq Services.ProdsRequest
	err := ginCtx.Bind(&prodReq)
	if err != nil {
		ginCtx.JSON(500, gin.H{"status": err.Error()})
	} else {
		prodRes, _ := prodService.GetProdsList(context.Background(), &prodReq)
		ginCtx.JSON(200, gin.H{"data": prodRes.Data})

		////熔断代码改造
		////第一步，配置config
		//configA:=hystrix.CommandConfig{
		//	Timeout:1000,
		//}
		////第二步：配置command
		//hystrix.ConfigureCommand("getprods",configA)
		////第三步：执行，使用Do方法
		//var prodRes *Services.ProdListResponse
		//err:=hystrix.Do("getprods", func() error {
		//	prodRes,err= prodService.GetProdsList(context.Background(),&prodReq)
		//	return err
		//}, func(e error) error {
		//	prodRes,err=defaultProds()
		//	return err
		//})
		//
		//if err!=nil{
		//	ginCtx.JSON(500,gin.H{"status":err.Error()})
		//}else{
		//	ginCtx.JSON(200,gin.H{"data":prodRes.Data})
		//}

	}

}
