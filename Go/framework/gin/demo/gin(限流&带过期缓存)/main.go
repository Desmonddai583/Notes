package main

import (
	"ratelimit/lib"

	"github.com/gin-gonic/gin"
)

func test(c *gin.Context) {
	c.JSON(200, gin.H{"message": "Ok"})
}
func main() {

	r := gin.New()
	r.GET("/", lib.IPLimiter(10, 1)(test))

	r.Run(":8080")
}
