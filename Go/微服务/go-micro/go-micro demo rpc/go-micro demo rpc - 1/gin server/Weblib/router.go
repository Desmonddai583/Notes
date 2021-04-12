package Weblib

import (
	"github.com/gin-gonic/gin"
	"gomicro.jtthink.com/Services"
)

func NewGinRouter(prodService Services.ProdService) *gin.Engine {
	ginRouter := gin.Default()
	ginRouter.Use(InitMiddleware(prodService))
	v1Group := ginRouter.Group("/v1")
	{
		v1Group.Handle("POST", "/prods", GetProdsList)
	}
	return ginRouter
}
