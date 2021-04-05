package main

import (
	"flag"
	"fmt"
	"log"
	"net/http"
	"os"
	"os/signal"
	"strconv"
	"syscall"

	kitlog "github.com/go-kit/kit/log"
	httptransport "github.com/go-kit/kit/transport/http"
	mymux "github.com/gorilla/mux"
	"golang.org/x/time/rate"
	. "service.jtthink.com/Services"
	"service.jtthink.com/util"
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
	util.SetServiceNameAndPort(*name, *port) //设置服务名和端口

	var logger kitlog.Logger
	{
		logger = kitlog.NewLogfmtLogger(os.Stdout)
		logger = kitlog.WithPrefix(logger, "mykit", "1.0")
		logger = kitlog.With(logger, "time", kitlog.DefaultTimestampUTC)
		logger = kitlog.With(logger, "caller", kitlog.DefaultCaller)
	}

	user := UserService{} //用户服务
	limit := rate.NewLimiter(1, 5)
	endp := RateLimit(limit)(UserServiceLogMiddleware(logger)(CheckTokenMiddleware()(GenUserEndpoint(user))))

	options := []httptransport.ServerOption{
		httptransport.ServerErrorEncoder(MyErrorEncoder),
	}
	serverHanlder := httptransport.NewServer(endp, DecodeUserRequest, EncodeUserResponse, options...)

	//增加handler 用于获取用户token
	accessService := &AccessService{}
	accessServiceEndpoint := AccessEndpoint(accessService)
	accessHandler := httptransport.NewServer(accessServiceEndpoint, DecodeAccessRequest, EncodeAccessResponse, options...)

	router := mymux.NewRouter() //路由，使用的是第三方mux路由
	{
		router.Methods("POST").Path("/access-token").Handler(accessHandler)
		router.Methods("GET", "DELETE").Path(`/user/{uid:\d+}`).Handler(serverHanlder)
		router.Methods("GET").Path("/health").HandlerFunc(func(writer http.ResponseWriter, request *http.Request) {
			writer.Header().Set("Content-type", "application/json")
			writer.Write([]byte(`{"status":"ok"}`))
		})
	}
	errChan := make(chan error)
	go (func() {
		//util.RegService() //注册服务
		err := http.ListenAndServe(":"+strconv.Itoa(*port), router)
		if err != nil {
			log.Println(err)
			errChan <- err
		}
	})()
	go (func() {
		sig_c := make(chan os.Signal)
		signal.Notify(sig_c, syscall.SIGINT, syscall.SIGTERM)
		errChan <- fmt.Errorf("%s", <-sig_c)
	})()

	getErr := <-errChan
	//util.Unregservice()
	log.Println(getErr)

}
