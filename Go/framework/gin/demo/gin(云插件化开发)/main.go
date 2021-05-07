package main

import (
	"ginplugin/plugins"
	"log"
	"time"

	"github.com/gin-gonic/gin"
)

func main() {
	r := gin.New()
	r.Use(func(c *gin.Context) {
		plugins.PluginList.Range(func(key, value interface{}) bool {
			value.(*plugins.PluginModel).GetHandler().ServeHTTP(c.Writer, c.Request)
			log.Println("插件:", key, "执行完毕")
			return true
		})
		c.Next()
	})
	go func() {
		for {
			//运行 任务
			plugins.StartJob()
			time.Sleep(time.Second * 3) // 间隔三秒 ,, 20-30分钟
		}

	}()
	r.GET("/", func(c *gin.Context) {
		c.JSON(200, gin.H{"message": "OK"})
	})
	r.Run(":8080")
}
