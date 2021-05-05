package main

import (
	"ginskill/src/common"
	"ginskill/src/dbs"
	"ginskill/src/handlers"
	"github.com/gin-gonic/gin"
	_ "ginskill/src/validators"

)
func main() {
	dbs.InitDB()
	dbs.InitTable()
	r:=gin.New()

	r.Use(common.ErrorHandler())
	r.GET("/users", handlers.UserList)
	r.GET("/users/:id", handlers.UserDetail)

	r.POST("/users",handlers.UserSave)


	r.Run(":8080")


}
