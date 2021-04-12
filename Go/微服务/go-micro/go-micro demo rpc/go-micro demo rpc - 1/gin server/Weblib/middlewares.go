package Weblib

import (
	"github.com/gin-gonic/gin"
	"gomicro.jtthink.com/Services"
)

func InitMiddleware(prodService Services.ProdService) gin.HandlerFunc {
	return func(context *gin.Context) {
		context.Keys = make(map[string]interface{})
		context.Keys["prodservice"] = prodService //赋值
		context.Next()
	}
}
