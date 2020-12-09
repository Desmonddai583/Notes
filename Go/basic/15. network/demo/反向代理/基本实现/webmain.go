package main

import (
	"encoding/base64"
	"fmt"
	"log"
	"net/http"
	"os"
	"os/signal"
	"strings"
	"time"
)
type web1handler struct {
}
func(web1handler) GetIP(request *http.Request) string{
	ips:=request.Header.Get("x-forwarded-for")
	if ips!=""{
	ips_list:= strings.Split(ips, ",")
		if len(ips_list)>0 && ips_list[0]!=""{
			return ips_list[0]
		}
	}
	return request.RemoteAddr
}


func(this web1handler) ServeHTTP(writer http.ResponseWriter, request *http.Request)  {

	auth:=request.Header.Get("Authorization")
	if auth==""{
	 	writer.Header().Set("WWW-Authenticate", `Basic realm="您必须输入用户名和密码"`)
		writer.WriteHeader(http.StatusUnauthorized)
		return
	}
	auth_list:=strings.Split(auth," ") //切割字符串
	if len(auth_list)==2 && auth_list[0]=="Basic" {  //判断basic auth 是否合法
		res,err:=base64.StdEncoding.DecodeString(auth_list[1])
		if err==nil && string(res)=="shenyi:123" {
			writer.Write([]byte(fmt.Sprintf("<h1>web1,来自于:%s</h1>",this.GetIP(request))))
			return
		}
	}
	writer.Write([]byte("用户名密码错误"))




}
type web2handler struct {}

func(web2handler) ServeHTTP(writer http.ResponseWriter, request *http.Request)  {

	time.Sleep(3*time.Second)
	 writer.Write([]byte("web2"))

}

func main()  {
	c:=make(chan os.Signal)
	go(func() {
		http.ListenAndServe(":9091",web1handler{})
	})()
	go(func() {


		http.ListenAndServe(":9092",web2handler{})
	})()
	signal.Notify(c,os.Interrupt)
	s:=<-c
	log.Println(s)
}