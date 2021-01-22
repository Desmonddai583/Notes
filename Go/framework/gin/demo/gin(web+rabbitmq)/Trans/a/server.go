package main

import (
	"encoding/json"
	"log"

	"github.com/gin-gonic/gin"
	"rmq.jtthink.com/Lib"
	"rmq.jtthink.com/Trans"
)

func main() {
	router := gin.Default()
	router.Use(Trans.ErrorMiddleware())
	router.Handle("POST", "/", func(context *gin.Context) {

		tm := Trans.NewTransModel()
		err := context.BindJSON(&tm)
		Trans.CheckError(err, "参数失败:")

		//执行转账--A公司
		err = Trans.TransMoney(tm)
		Trans.CheckError(err, "转账失败-A:") //如果到这一步爆炸了
		//发送到MQ
		mq := Lib.NewMQ()
		jsonb, _ := json.Marshal(tm)
		err = mq.SendMessage(Lib.ROUTER_KEY_TRANS, Lib.EXCHANGE_TRANS, string(jsonb))
		if err != nil {
			log.Println(err)
		}

		context.JSON(200, gin.H{"result": tm.String()})

	})

	//回调函数
	router.Handle("POST", "/callback", func(context *gin.Context) {
		tid := context.PostForm("tid")
		sql := "update translog set status=1 where tid=? and status=0"
		ret, err := Trans.GetDB().Exec(sql, tid)
		affCount, err2 := ret.RowsAffected()
		if err != nil || err2 != nil || affCount != 1 {
			context.String(200, "error")
		} else {
			context.String(200, "success")
		}
	})
	c := make(chan error)
	go func() {
		err := router.Run(":8080")
		if err != nil {
			c <- err
		}
	}()
	go func() {
		err := Trans.DBInit("a")
		if err != nil {
			c <- err
		}
	}()
	go func() {
		err := Lib.TransInit()
		if err != nil {
			c <- err
		}
	}()
	err := <-c
	log.Fatal(err)
}
