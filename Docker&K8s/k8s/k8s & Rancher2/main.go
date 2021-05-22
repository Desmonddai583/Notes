package main

import (
	"regexp"

	"github.com/gin-gonic/gin"
)

func isAllNumber(str string) bool {
	reg := regexp.MustCompile(`^\d+$`)
	return reg.MatchString(str)
}

func main() {
	r := gin.New()
	r.GET("/", func(context *gin.Context) {
		context.JSON(200, gin.H{"result": "this is my index"})
	})
	r.Run(":80")

}
