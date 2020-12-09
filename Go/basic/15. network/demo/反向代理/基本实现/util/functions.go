package util

import (
	"io/ioutil"
	"log"
	"net"
	"net/http"
	"time"
)

func CloneHeader(src http.Header,dest *http.Header)  {
   for k,v:=range src{
	   dest.Set(k,v[0])
   }
}
func RequestUrl(w http.ResponseWriter, r *http.Request,url string)  {
	newreq,_:=http.NewRequest(r.Method,url,r.Body)
	CloneHeader(r.Header,&newreq.Header)
	newreq.Header.Add("x-forwarded-for",r.RemoteAddr)

	dt:=&http.Transport{
		DialContext: (&net.Dialer{
			Timeout:   30 * time.Second,
			KeepAlive: 30 * time.Second,
		}).DialContext,
		ResponseHeaderTimeout:1*time.Second,
	}

   newresponse,err:=dt.RoundTrip(newreq)
	if err!=nil{
		log.Println(err)
		return
	}
	getHeader:=w.Header()
	CloneHeader(newresponse.Header,&getHeader) //拷贝响应头 给客户端

	w.WriteHeader(newresponse.StatusCode) // 写入http status

	defer newresponse.Body.Close()
	res_cont,_:=ioutil.ReadAll(newresponse.Body)
	w.Write(res_cont)  // 写入响应给客户端
}