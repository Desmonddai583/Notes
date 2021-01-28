package main

import (
	"context"
	"flag"
	"fmt"
	"goetcd/util"
	"log"
	"net/http"
	"os"
	"os/signal"
	"strconv"
	"syscall"

	"github.com/gorilla/mux"
)

func main() {
	name := flag.String("name", "", "服务名称")
	port := flag.Int("p", 0, "服务端口")
	flag.Parse()
	if *name == "" {
		log.Fatal("请指定服务名")
	}
	if *port == 0 {
		log.Fatal("请指定端口")
	}

	service := util.NewService()
	serviceID := uuid.NewV4().String() //这里改动了
	serviceName := *name               //注意这里
	serviceAddr := "192.168.29.1"
	servicePort := *port //注意这里

	router := mux.NewRouter()
	router.HandleFunc("/product/{id:\\d+}", func(writer http.ResponseWriter, request *http.Request) {
		vars := mux.Vars(request)
		str := "get product ByID:" + vars["id"] + ",port:" + strconv.Itoa(*port)
		writer.Write([]byte(str))
	})

	errChan := make(chan error)

	httpServer := &http.Server{
		Addr:    ":" + strconv.Itoa(servicePort),
		Handler: router,
	}
	go (func() {
		err := service.RegService(serviceID, serviceName, serviceAddr+":"+strconv.Itoa(servicePort))
		if err != nil {
			errChan <- err
			return
		}
		err = httpServer.ListenAndServe()
		if err != nil {
			errChan <- err
			return
		}
	})()

	go (func() {
		sig := make(chan os.Signal)
		signal.Notify(sig, syscall.SIGINT, syscall.SIGTERM)
		errChan <- fmt.Errorf("%s", <-sig)
	})()

	getErr := <-errChan
	err := service.UnregService(serviceID) //反注册
	if err != nil {
		fmt.Println(err)
	}
	//可以执行一些 回收工作，譬如关闭数据库
	err = httpServer.Shutdown(context.Background())
	if err != nil {
		log.Fatal(err)
	}
	log.Fatal(getErr)

}
