package lib

import (
	"strings"

	"github.com/gin-gonic/gin"
)

func CheckLogin() gin.HandlerFunc {
	return func(context *gin.Context) {
		if context.Request.Header.Get("token") == "" {
			context.AbortWithStatusJSON(400, gin.H{"message": "token required"})
		} else {
			context.Set("user_name", context.Request.Header.Get("token"))
			context.Next()
		}
	}
}
func RBAC() gin.HandlerFunc {
	return func(context *gin.Context) {
		user, _ := context.Get("user_name")
		// access,err:=E.Enforce(user,context.Request.RequestURI,context.Request.Method)
		domain := context.Param("domain")
		uri := strings.TrimPrefix(context.Request.RequestURI, "/"+domain) //  /domain1/depts=>/depts
		access, err := E.Enforce(user, domain, uri, context.Request.Method)
		if err != nil || !access {
			context.AbortWithStatusJSON(403, gin.H{"message": "forbidden"})
		} else {
			context.Next()
		}
	}
}
func Middlewares() (fs []gin.HandlerFunc) {
	fs = append(fs, CheckLogin(), RBAC())
	return
}
