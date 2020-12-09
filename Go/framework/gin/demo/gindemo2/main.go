package main

import (
	"context"
	"log"
	"net/http"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/gin-gonic/gin/binding"
	"github.com/gomodule/redigo/redis"
	_ "github.com/jinzhu/gorm/dialects/mysql"
	"gopkg.in/go-playground/validator.v8"
	. "topic.jtthink.com/src"
)

func main2() {
	conn := RedisDefaultPool.Get()
	ret, err := redis.String(conn.Do("get", "nameff"))
	if err != nil {
		log.Println(err)
		return
	}
	log.Println(ret)
}

func main() {
	router := gin.Default()
	if v, ok := binding.Validator.Engine().(*validator.Validate); ok {
		v.RegisterValidation("topicurl", TopicUrl)
		v.RegisterValidation("topics", TopicsValidate) //验证长度
	}
	v1 := router.Group("/v1/topics") //单条帖子 路由
	{
		v1.GET("", GetTopicList)
		v1.GET("/:topic_id", CacheDecorator(GetTopicDetail, "topic_id", "topic_%s", Topics{}))

		v1.Use(MustLogin())
		{
			v1.POST("", NewTopic)
			v1.DELETE("/:topic_id", DelTopic)
		}

	}
	v2 := router.Group("/v1/mtopics") //多条帖子 路由
	{
		v2.Use(MustLogin())
		{
			v2.POST("", NewTopics)

		}
	}

	server := &http.Server{
		Addr:    ":8080",
		Handler: router,
	}
	go (func() { //启动web服务
		err := server.ListenAndServe()
		if err != nil {
			log.Fatal("服务器启动失败")
		}
	})()
	go (func() {
		InitDB()
		log.Println("数据库初始化成功")
	})()

	ServerNotify()
	//这里还可以做一些 释放连接或善后工作，暂时略
	ctx, cancel := context.WithTimeout(context.Background(), time.Second*5)
	defer cancel()
	err := server.Shutdown(ctx)
	if err != nil {
		log.Fatalln("服务器关闭")
	}
	log.Println("服务器优雅退出")

}
