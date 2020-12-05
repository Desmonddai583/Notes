package main

import (
	"net/http"

	"com.jtthink.net/myhttpserver/core"
)

type MyHandler struct {

}
func(*MyHandler) ServeHTTP(writer http.ResponseWriter, request *http.Request){

	 writer.Write([]byte("hello,myhandler"))
}

func main()  {

	router:=core.DefaultRouter()

	router.Add("/",&NewsController{})

	http.ListenAndServe(":8099",router)


}
