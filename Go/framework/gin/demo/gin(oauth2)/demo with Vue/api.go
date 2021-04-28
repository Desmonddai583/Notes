package main

import (
	"goauth/utils"

	"github.com/gin-gonic/gin"
)

type Dept struct {
	DeptId   int
	DeptName string
}

func deptsList() (list []*Dept) {
	list = append(list, &Dept{100, "部门1"}, &Dept{101, "部门2"})
	return
}
func main() {
	r := gin.Default()
	r.Use(utils.ErrorHandler(), utils.CheckToken())
	r.GET("/depts", func(context *gin.Context) {
		context.JSON(200, deptsList())
	})
	r.Run(":8080")
}
