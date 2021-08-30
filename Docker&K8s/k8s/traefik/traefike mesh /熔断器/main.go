package main

import (
	"github.com/gin-gonic/gin"
	"time"
)

func main()  {
	 r:=gin.New()
	r.GET("/", func(c *gin.Context) {
		c.JSON(200,gin.H{"message":"正常输出"})
	})
	 r.GET("/delay", func(c *gin.Context) {
		  time.Sleep(time.Second*3)
		  c.JSON(200,gin.H{"message":"延迟"})
	 })
	r.GET("/err", func(c *gin.Context) {

		c.JSON(400,gin.H{"message":"异常输出"})
	})
	 r.Run(":80")

}
