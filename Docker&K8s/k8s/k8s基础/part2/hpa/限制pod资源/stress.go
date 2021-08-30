package main

import (
	"encoding/json"
	"github.com/gin-gonic/gin"

)

func main() {
	test:=map[string]string{
		"str":"requests来设置各容器需要的最小资源",
	}
  r:=gin.New()
  r.GET("/", func(context *gin.Context) {
  	ret:=0
  	for i:=0;i<=1000000;i++{
  		t:=map[string]string{}
  		b,_:=json.Marshal(test)
  		_=json.Unmarshal(b,t)
  		ret++
	}
	  context.JSON(200,gin.H{"message":ret})
  })
  r.Run(":8080")
}
