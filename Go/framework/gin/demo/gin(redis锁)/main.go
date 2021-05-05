package main

import (
	"locpro/lib"
	"time"

	"github.com/gin-gonic/gin"
)

var a = 1

func main() {
	r := gin.New()
	r.Use(func(c *gin.Context) {
		defer func() {
			if e := recover(); e != nil {
				c.AbortWithStatusJSON(400, gin.H{"message": e})
			}
		}()
		c.Next()
	})
	r.GET("/", func(c *gin.Context) {
		locker := lib.NewLockerWithTTL("lock1", time.Second*3).Lock()
		defer locker.Unlock()
		if c.Query("t") != "" {
			time.Sleep(5 * time.Second) //模拟卡顿 5秒
		}
		a++

		c.JSON(200, gin.H{"message": a})
	})
	r.Run(":8080")

}
