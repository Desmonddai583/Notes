package main

import (
	"fmt"
	"github.com/gin-gonic/gin"
	 "net/url"
)

func main()  {
	r:=gin.New()
	r.Any("/", func(c *gin.Context) {
		getUrl:=c.GetHeader("X-Forwarded-Uri")
		getUser:=c.GetHeader("X-Auth-User")
		getMethod:=c.GetHeader("X-Forwarded-Method")
		fmt.Println(getUrl,getUser,getMethod)

		if checkAccess(getUrl,getUser,getMethod){  //检查权限
			c.JSON(200,gin.H{"message":"ok"})
		}else{
			c.JSON(401,gin.H{"message":"access denied"})
		}

	})
	r.Run(":80")
}
var allowAccess=map[string][]map[string]string{
	"shenyi": {
		map[string]string{"method": "POST", "path": "/depts"},
		map[string]string{"method": "GET", "path": "/depts"},
	},
	"lisi": {
		map[string]string{"method": "GET", "path": "/depts"},
	},
}
func checkAccess(urlstr string,user string,method string  ) bool{
	 if urlstr=="" || user=="" {
	 	return false
	 }
	url,err:= url.ParseRequestURI(urlstr)
	if err!=nil{
		return false
	}
	if accesss,ok:=allowAccess[user];ok{
		for _,access:=range accesss{
			if method==access["method"] && url.Path==access["path"]  {
				return true
			}
		}
	}
	return false
}