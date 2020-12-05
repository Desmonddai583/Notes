package main

import (
	"regexp"
	"fmt"
	"os"
	"io/ioutil"
)

func GetRequestPath(rq string) string  {
	r:=regexp.MustCompile(`^GET\s(.*?)\sHTTP`)
	if r.MatchString(rq) {
		return r.FindStringSubmatch(rq)[1]
	} else{
		return "/"
	}
}
func response(body []byte,status HttpStatus) string {
	str:=`HTTP/1.1 %d %s
Server: myserver
Content-Type: text/html

%s
`
	ret:= fmt.Sprintf(str,status.Code,status.Message,body)
	return ret
}
func  ExistsFile(path string) (bool,error)  {
	_,err:=os.Stat("./web"+path)
 	if err==nil {
 		return true,nil
	}else{
		if os.IsNotExist(err){//不存在
			return false,nil
		}else{
			return false,err
		}
	}
}
func ReadHtml(path string) string  {
	exist,_:=ExistsFile(path)
	if exist {
		file,_:=ioutil.ReadFile("./web"+path)
		return response(file,NewHttpStatus(200,"OK"))

	}else{
		return response([]byte("404"),NewHttpStatus(404,"Not Found"))
	}
}
