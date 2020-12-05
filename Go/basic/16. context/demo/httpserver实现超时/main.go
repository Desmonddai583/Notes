package main

import (
	"context"
	"net/http"
	"time"
)

func CountData(c chan string) chan string {
	time.Sleep(time.Second * 2)
	c <- "统计结果"
	return c
}

type IndexHandler struct{}

func (this *IndexHandler) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	if r.URL.Query().Get("count") == "" {
		w.Write([]byte("这是首页"))
	} else {
		ctx, cancel := context.WithTimeout(r.Context(), time.Second*3)
		defer cancel()
		c := make(chan string)
		go CountData(c)
		select {
		case <-ctx.Done():
			w.Write([]byte("超时"))
		case ret := <-c:
			w.Write([]byte(ret))
		}
	}
}

func main() {
	mux := http.NewServeMux()
	mux.Handle("/", new(IndexHandler))

	http.ListenAndServe(":8082", mux)
}
