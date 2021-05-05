package main

import (
	"eventbus/services"
	"github.com/gin-gonic/gin"
	"time"
)

func main() {
	services.InitJSONBroker()
    r:=gin.New()
    r.Use(func(c *gin.Context) {
		defer func() {
			if e:=recover();e!=nil{
				c.JSON(400,gin.H{"message":e})
			}
		}()
		c.Next()
	})
    r.GET("/users/:id", func(c *gin.Context) {
    	id:=c.Param("id")
    	result:=make(map[string]interface{})
		err:=services.JSONBroker.Request("users.get.info",id,&result,time.Second)
		if err!=nil{
			panic(err)
		}
		c.JSON(200,gin.H{"result":result,"code":200})

	})
    r.Run(":80")
}
