package core

import (
	"net/http"
)
type MyHandlerFunc func(ctx *MyContext)
type MyRouter struct {
	Mapping map[string]ControllerInterface

}

func DefaultRouter() *MyRouter {
	 return &MyRouter{make(map[string]ControllerInterface)}
}
//加入 path 和Controller的对应关系
func(this *MyRouter) Add(path string,c ControllerInterface)  {
	this.Mapping[path]=c
}

func(this *MyRouter) ServeHTTP(writer http.ResponseWriter, request *http.Request){
	//chrome 会默认请求图标地址
	if f,OK:=this.Mapping[request.URL.Path];OK{
		 f.Init(&MyContext{request,writer}) //关键代码
		 if request.Method=="GET"{//没有做防错处理
		 	f.GET()
		 }
		if request.Method=="POST"{//没有做防错处理
			f.POST()
		}
	}




}