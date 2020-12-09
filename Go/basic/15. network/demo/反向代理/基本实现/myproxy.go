package main

import (
	"log"
	"net/http"
	"net/http/httputil"
	"net/url"
	"regexp"

	. "proxy.jtthink.com/util"
)

type ProxyHandler struct{}

func (*ProxyHandler) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	defer func() {
		if err := recover(); err != nil {
			w.WriteHeader(500)
			log.Println(err)
		}
	}()
	for k, v := range ProxyConfigs {
		if matched, _ := regexp.MatchString(k, r.URL.Path); matched == true {
			target, _ := url.Parse(v) //v是目标网站地址
			proxy := httputil.NewSingleHostReverseProxy(target)
			proxy.ServeHTTP(w, r)
			// RequestUrl(w,r,v)//开始反代处理
			return
		}
	}
	w.Write([]byte("default index"))
}

func main() {
	//fmt.Println(base64.StdEncoding.EncodeToString([]byte("shenyi:123")))
	http.ListenAndServe(":8080", &ProxyHandler{})
}
