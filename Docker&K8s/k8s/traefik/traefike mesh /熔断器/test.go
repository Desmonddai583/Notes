package main

import (
	"io/ioutil"
	"log"
	"net/http"
	"time"
)
func request(){
	start := time.Now()
	req,err:=http.NewRequest("GET","http://myapi.jtthink.com:8000/delay",nil )
	if err!=nil{
		log.Fatal(err)
	}
	rsp,err:=http.DefaultClient.Do(req)
	if err!=nil || rsp.StatusCode>=300{
		end := time.Since(start)
		log.Printf("执行异常:code=%d，耗时%d毫秒\n",rsp.StatusCode,
			end.Nanoseconds()/int64(time.Millisecond))
		return
	}
	defer rsp.Body.Close()
	end := time.Since(start)
	_,_=ioutil.ReadAll(rsp.Body)
	log.Printf("执行成功,耗时:%d毫秒",end.Nanoseconds()/int64(time.Millisecond))
}
func main() {

	count:=0
	for {
		if count>=20{
			break
		}
		request()
		time.Sleep(time.Second)
		count++

	}
}
