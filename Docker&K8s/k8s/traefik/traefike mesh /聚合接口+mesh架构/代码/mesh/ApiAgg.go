package main

import (
	"github.com/gin-gonic/gin"
	"github.com/golang/protobuf/proto"
	"mygrpc/lib"
	"mygrpc/pbfiles"
	"time"
)

func checkError(err error)  {
	if err!=nil{
		panic(err)
	}
}
func main() {

	lib.InitBroker()
	r:=gin.New()
	r.Use(func(c *gin.Context) {
		defer func() {
			if e:=recover();e!=nil{
				c.AbortWithStatusJSON(400,gin.H{"error":e.(error).Error()})
			}
		}()
		c.Next()
	})
	r.GET("/prods/hot", func(c *gin.Context) {
		   req:=&pbfiles.HotProdRequest{Size:5}
		   reqBytes,err:=proto.Marshal(req)
			checkError(err)
			msg,err:=lib.Broker.Request("prods.get.hot",reqBytes,time.Second*2)
		    checkError(err)
			rsp:=&pbfiles.HotProdResponse{}
		    checkError(proto.Unmarshal(msg.Data,rsp))
		 	c.JSON(200,rsp)
	})

    r.Run(":8080")

}
