package main

import (
	"mypro/services"
	"time"

	"github.com/gin-gonic/gin"
)

func main() {
	r := gin.New()
	r.GET("/prods", func(c *gin.Context) {
		ch := services.GetProdListCh()

		services.Bus.Pub(services.GetList_Prods, ch, "1")
		defer services.Bus.UnSub(services.GetList_Prods, ch)
		services.Bus.PrintNum(services.GetList_Prods)

		c.JSON(200, ch.Data(time.Second))
	})

	r.Run(":8080")

}
