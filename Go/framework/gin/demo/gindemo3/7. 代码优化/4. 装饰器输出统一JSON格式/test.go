package main

import (
	. "ginskill/src/code"

	"github.com/gin-gonic/gin"
)

func main() {
	r := gin.New()
	r.GET("/users", Handler()(GetUserList))
	r.GET("/users/:id", Handler()(GetUserDetail))

	r.Run(":8080")

}
