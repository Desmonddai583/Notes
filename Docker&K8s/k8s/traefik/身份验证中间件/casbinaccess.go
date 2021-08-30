package main

import (
	"fmt"
	"github.com/casbin/casbin/v2"
	"github.com/gin-gonic/gin"
	"log"
	"net/url"

)

var E *casbin.Enforcer
func RBAC() gin.HandlerFunc  {
	return func(c *gin.Context) {
		user:=c.GetHeader("X-Auth-User")
		getMethod:=c.GetHeader("X-Forwarded-Method")
		getUrl:=c.GetHeader("X-Forwarded-Uri")
		uri,err:= url.ParseRequestURI(getUrl)
		if err!=nil{
			c.AbortWithStatusJSON(403,gin.H{"message":"forbidden"})
			log.Println(err)
			return
		}
		fmt.Println(user,uri.Path,getMethod)
		access,err:=E.Enforce(user,uri.Path,getMethod)
		if err!=nil || !access{
			c.AbortWithStatusJSON(403,gin.H{"message":"forbidden"})
		}else{
			c.Next()
		}
	}
}
func main()  {
	e,err:= casbin.NewEnforcer("model.conf","p.csv")
	if err!=nil{
		log.Fatal(err)
	}
	E=e
	r:=gin.New()
	r.Use(RBAC())
	r.Any("/", func(c *gin.Context) {
		c.JSON(200,gin.H{"message":"ok"})
	})
	r.Run(":80")
}