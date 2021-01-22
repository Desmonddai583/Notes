package Trans

import (
	"fmt"

	"github.com/gin-gonic/gin"
)

func CheckError(err error, msg string) {
	if err != nil {
		panic(fmt.Sprintf("%s%s", msg, err.Error()))
	}
}
func ErrorMiddleware() gin.HandlerFunc {
	return func(context *gin.Context) {
		defer func() {
			if err := recover(); err != nil {
				context.AbortWithStatusJSON(400, gin.H{"error": err})
			}
		}()
		context.Next()
	}
}
