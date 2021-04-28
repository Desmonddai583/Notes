package utils

import (
	"log"

	"github.com/gin-gonic/gin"
)

func ErrorHandler() gin.HandlerFunc {
	return func(context *gin.Context) {
		defer func() {
			if e := recover(); e != nil {
				context.JSON(400, gin.H{"message": e})
			}
		}()
		context.Next()
	}
}

func CheckToken() gin.HandlerFunc {
	return func(context *gin.Context) {
		if token := context.Query("token"); token != "" {
			passport := GetUserInfo("http://oauth.me.com/info", token, true)
			userID := passport.UserId
			if userID == "" {
				log.Println("token不合法")
				context.AbortWithStatus(401)
			} else {
				log.Printf("%s访问了%s", userID, context.Request.RequestURI)
				context.Next()
			}

		} else {
			context.AbortWithStatus(401)
		}
	}
}
