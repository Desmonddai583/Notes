package main

// go中的接口只要实现者实现了接口定义的方法就可以拿来使用，不需要显示声明

import (
	"fmt"
	"time"

	"../interface/mock"
	"../interface/real"
)

// Retriever 定義Retriever接口
type Retriever interface {
	Get(url string) string
}

// Poster 定義Poster接口
type Poster interface {
	Post(url string,
		form map[string]string) string
}

const url = "http://www.imooc.com"

func download(r Retriever) string {
	return r.Get(url)
}

func post(poster Poster) {
	poster.Post(url,
		map[string]string{
			"name":   "ccmouse",
			"course": "golang",
		})
}

// RetrieverPoster 定義RetrieverPoster接口
// 接口組合
type RetrieverPoster interface {
	Retriever
	Poster
}

func session(s RetrieverPoster) string {
	s.Post(url, map[string]string{
		"contents": "another faked imooc.com",
	})
	return s.Get(url)
}

func main() {
	var r Retriever

	// 接口变量里面会存放着实现者的类型和值(或者也可以是实现者的指针)
	// 接口变量同样采用值传递，几乎不需要使用接口的指针(因为内部已经有一个实现者的指针)
	// 接口中的方法如果是使用指针接收者实现只能以指针方式使用,例如下面传给r的就必须传递一个地址
	// 但是如果接口中的方法是值接受者则传给r既可传地址又可传值
	// 如果把类型设置为interface{} 则可以代表任何类型

	mockRetriever := mock.Retriever{
		Contents: "this is a fake imooc.com"}
	r = &mockRetriever
	inspect(r)

	// 这里因为real.Retriever的Get接收者是一个指针，所以要传地址
	r = &real.Retriever{
		UserAgent: "Mozilla/5.0",
		TimeOut:   time.Minute,
	}
	inspect(r)

	// Type assertion，可以通过这个方法来取得实现者里面的具体类型
	if mockRetriever, ok := r.(*mock.Retriever); ok {
		fmt.Println(mockRetriever.Contents)
	} else {
		fmt.Println("r is not a mock retriever")
	}

	fmt.Println(
		"Try a session with mockRetriever")
	fmt.Println(session(&mockRetriever))
}

func inspect(r Retriever) {
	fmt.Println("Inspecting", r)
	fmt.Printf(" > Type:%T Value:%v\n", r, r)
	fmt.Print(" > Type switch: ")
	switch v := r.(type) {
	case *mock.Retriever:
		fmt.Println("Contents:", v.Contents)
	case *real.Retriever:
		fmt.Println("UserAgent:", v.UserAgent)
	}
	fmt.Println()
}
