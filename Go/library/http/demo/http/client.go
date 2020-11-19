package main

// 通过在调用httpserver时引用 _ "net/http/pprof"
// 在/debug/pprof/的url路径下就可以查看性能状况
// 另外调用go tool pprof http://localhost:8888/debug/pprof/profile就可以查看cpu30秒的运行情况
// 在调用并且运行30秒之后就会进入互动模式，输入web就可以打开性能图，帮助我们之后进行优化
// pprof后面除了profile，还有一些其他选项去查看不同的资源性能使用，具体可以参考pprof的帮助文档

import (
	"fmt"
	"net/http"
	"net/http/httputil"
)

func main() {
	request, err := http.NewRequest(
		http.MethodGet,
		"http://www.imooc.com", nil)
	request.Header.Add("User-Agent",
		"Mozilla/5.0 (iPhone; CPU iPhone OS 10_3 like Mac OS X) AppleWebKit/602.1.50 (KHTML, like Gecko) CriOS/56.0.2924.75 Mobile/14E5239e Safari/602.1")

	// resp, err := http.DefaultClient.Do(request)
	// 这里我们自己定义一个client来代替DefaultClient
	// redirect可以有多次，via就定义了每一个重定向
	client := http.Client{
		CheckRedirect: func(
			req *http.Request,
			via []*http.Request) error {
			fmt.Println("Redirect:", req)
			// 返回nil是就会重定向
			// 如果返回错误则终止重定向
			return nil
		},
	}
	resp, err := client.Do(request)
	if err != nil {
		panic(err)
	}
	defer resp.Body.Close()

	s, err := httputil.DumpResponse(resp, true)
	if err != nil {
		panic(err)
	}

	fmt.Printf("%s\n", s)
}
