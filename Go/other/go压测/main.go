package main

import (
	"fmt"
	"net/http"
	"time"

	"github.com/myzhan/boomer"
)

func reqWeb(name string, url string) {
	start := time.Now()
	rsp, err := http.Get(url)
	if err != nil {
		boomer.RecordFailure("http", name, 0,
			fmt.Sprintf("request err:%s", err.Error()))
		return
	}
	defer rsp.Body.Close()
	end := time.Since(start)
	if rsp.StatusCode >= 400 {
		boomer.RecordFailure("http", name, end.Nanoseconds()/int64(time.Millisecond),
			fmt.Sprintf("status code:%d", rsp.StatusCode))
	} else {
		boomer.RecordSuccess("http", name,
			end.Nanoseconds()/int64(time.Millisecond), rsp.ContentLength)
	}
}
func main() {
	index := &boomer.Task{
		Name:   "myweb",
		Weight: 5,
		Fn: func() {
			reqWeb("index_page", "http://192.168.29.1:8080")
		},
	}
	prods := &boomer.Task{
		Name:   "myweb",
		Weight: 5,
		Fn: func() {
			reqWeb("prods_page", "http://192.168.29.1:8080/prods")
		},
	}

	boomer.Run(index, prods)
}
