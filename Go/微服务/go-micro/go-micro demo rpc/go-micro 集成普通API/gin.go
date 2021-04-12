package main

import (
	"context"
	"fmt"
	"net/http"
	"os"
	"os/signal"
	"syscall"

	"github.com/gin-gonic/gin"
	"github.com/go-acme/lego/v3/log"
	"github.com/google/uuid"
	"tools.jtthink.com/sidecar"
)

func main() {
	ginRouter := gin.Default()
	v1 := ginRouter.Group("/v1")
	{
		v1.Handle("POST", "/test", func(context *gin.Context) {
			context.JSON(200, gin.H{
				"data": "test",
			})
		})
	}
	server := &http.Server{
		Addr:    ":8088",
		Handler: ginRouter,
	}
	service := sidecar.NewService("api.jtthink.com.test")
	service.AddNode("test-"+uuid.New().String(), 8088, "192.168.29.1")
	handler := make(chan error)
	go (func() {
		handler <- server.ListenAndServe()
	})()
	go (func() {
		notify := make(chan os.Signal)
		signal.Notify(notify, syscall.SIGTERM, syscall.SIGINT, syscall.SIGKILL)
		handler <- fmt.Errorf("%s", <-notify)
	})()
	go (func() {
		//注册服务
		err := sidecar.RegService(service)
		if err != nil {
			handler <- err
		}
	})()
	getHandler := <-handler
	fmt.Println(getHandler.Error())
	//反注册服务
	err := sidecar.UnRegService(service)
	if err != nil {
		log.Println(err)
	}
	err = server.Shutdown(context.Background())
	if err != nil {
		log.Fatal(err)
	}

}
