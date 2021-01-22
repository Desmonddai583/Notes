package main

import (
	"encoding/json"
	"log"
	"net/http"
	"time"

	"github.com/bwmarrin/snowflake"
	"github.com/gin-gonic/gin"
	"rmq.jtthink.com/AppInit"
	"rmq.jtthink.com/AsyncOrder/models"
	"rmq.jtthink.com/Lib"
)

func getID() (string, error) {
	node, err := snowflake.NewNode(1)
	if err != nil {
		return "", err
	}
	return time.Now().Format("20060102") + node.Generate().String(), nil
}

//跨域设置，无技术含量
func CrosMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		c.Header("Access-Control-Allow-Origin", "*")
		c.Header("Access-Control-Allow-Headers", "Content-Type,AccessToken,X-CSRF-Token, Authorization, Token")
		c.Header("Access-Control-Allow-Methods", "POST, GET, OPTIONS")
		c.Header("Access-Control-Expose-Headers", "Content-Length, Access-Control-Allow-Origin, Access-Control-Allow-Headers, Content-Type")
		c.Header("Access-Control-Allow-Credentials", "true")
		if c.Request.Method == "OPTIONS" {
			c.AbortWithStatus(http.StatusNoContent)
		}
		c.Next()

	}
}
func main() {
	router := gin.Default()
	router.Use(CrosMiddleware())
	//用户请求下单
	router.Handle("POST", "/", func(context *gin.Context) {
		id, err := getID()
		//发送MQ
		req := &models.RequestModel{}
		_ = context.BindJSON(req)
		req.OrderNo = id //已知订单号
		req.OrderTime = time.Now()
		v, _ := json.Marshal(req)
		mq := Lib.NewMQ()
		err = mq.SendMessage("Key_Order", "Exchange_Order", string(v))
		if err != nil {
			log.Println(err)
		}
		if err != nil {
			context.JSON(400, gin.H{"error": "order fail"})
		} else {
			context.JSON(200, gin.H{"orderno": id})
		}
	})

	router.Handle("GET", "/result", func(context *gin.Context) {
		orderno := context.Query("orderno")
		//sqlx
		row := AppInit.GetDB().QueryRowx("select order_id from orders where order_no=?", orderno)
		id := 0
		err := row.Scan(&id)
		if err != nil {
			context.JSON(200, gin.H{"result": 0})
		} else {
			context.JSON(200, gin.H{"result": id})
		}

	})
	c := make(chan error)
	go func() {
		err := AppInit.DBInit()
		if err != nil {
			c <- err
		}
	}()
	go func() {
		err := router.Run(":8080")
		if err != nil {
			c <- err
		}
	}()
	go func() {
		err := Lib.OrderInit() //初始化
		if err != nil {
			c <- err
		}
	}()

	err := <-c
	log.Fatal(err)
}
