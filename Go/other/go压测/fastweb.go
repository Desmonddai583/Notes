package main

import (
	"fmt"
	"time"

	"github.com/myzhan/boomer"
	"github.com/valyala/fasthttp"
)

func req(name string, url string) {
	start := time.Now()

	req := fasthttp.AcquireRequest()
	defer fasthttp.ReleaseRequest(req)

	req.Header.SetMethod("GET") //get Get GET
	req.SetRequestURI(url)

	rsp := fasthttp.AcquireResponse()
	defer fasthttp.ReleaseResponse(rsp)

	err := fasthttp.Do(req, rsp)
	if err != nil {
		boomer.RecordFailure("http", name, 0,
			fmt.Sprintf("request err:%s", err.Error()))
		return
	}
	end := time.Since(start)
	if rsp.StatusCode() >= 400 {
		boomer.RecordFailure("http", name, end.Nanoseconds()/int64(time.Millisecond),
			fmt.Sprintf("status code:%d", rsp.StatusCode))
	} else {
		boomer.RecordSuccess("http", name,
			end.Nanoseconds()/int64(time.Millisecond), int64(rsp.Header.ContentLength()))
	}
}

func main() {
	userdetail := &boomer.Task{
		Name:   "myweb",
		Weight: 5,
		Fn: func() {
			req("userdetail", "http://192.168.29.1:8080/user/123")
		},
	}
	boomer.Run(userdetail)
}
