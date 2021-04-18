package main

import (
	"gcasbin/lib"

	"github.com/gin-gonic/gin"
)

func main() {
	r := gin.New()
	r.Use(lib.Middlewares()...)
	r.GET("/:domain/depts", func(context *gin.Context) {
		context.JSON(200, gin.H{"result": "部门列表--" + context.Param("domain")})
	})

	r.POST("/:domain/depts", func(context *gin.Context) {
		context.JSON(200, gin.H{"result": "批量修改部门列表" + context.Param("domain")})
	})

	r.Run(":8080")

}
