package main

import (
	"log"
	"net/http"

	"es.jtthink.com/Funs"
	"es.jtthink.com/Middlewares"
	"github.com/gin-gonic/gin"
	"github.com/gin-gonic/gin/binding"
	"gopkg.in/go-playground/validator.v9"
)

func main() {

	router := gin.New()
	router.Use(Middlewares.LogMiddleware(), gin.Recovery(), Middlewares.ErrorMiddleware()) //设置日志
	if v, ok := binding.Validator.Engine().(*validator.Validate); ok {
		err := v.RegisterValidation("mygte", func(fl validator.FieldLevel) bool {
			fl.Parent()
			param := fl.Param()
			v := fl.Parent().Elem().FieldByName(param)
			if !v.IsValid() {
				return false
			}
			if fl.Field().Float() >= v.Float() {
				return true
			}
			return false
		})
		if err != nil {
			log.Fatal(err)
		}
	}
	g := router.Group("/books") //业务相关
	{
		//图书列表
		g.Handle("GET", "", Funs.LoadBook)
		g.Handle("GET", "/press/:press", Funs.LoadBookByPress)
		g.Handle("POST", "/search", Funs.SearchBook) //搜索API
	}
	loggroup := router.Group("/log/aggs")
	{
		loggroup.Handle("GET", "/:type/:field", Funs.LogAgg)
	}
	//helper
	helper := router.Group("/helper")
	{
		helper.Handle("GET", "/press", Funs.PressList)
	}
	router.StaticFS("/ui", http.Dir("./htmls"))
	router.Run(":8080")

}
