package main

import (
	"log"
	"strconv"
	"time"

	"github.com/gin-gonic/gin"
	"rmq.jtthink.com/AppInit"
	"rmq.jtthink.com/Lib"
	"rmq.jtthink.com/UserReg/Models"
)

func main() {
	router := gin.Default()
	router.Handle("POST", "/user", func(context *gin.Context) {
		userModel := Models.NewUserModel()
		err := context.BindJSON(&userModel)
		if err != nil {
			context.JSON(400, gin.H{"result": "param error"})
		} else {
			userModel.UserId = int(time.Now().Unix()) //假设就是入库过程
			if userModel.UserId > 0 {                 //假设入库成功
				mq := Lib.NewMQ()
				mq.SetConfirm()   //开启confirm模式
				mq.NotifyReturn() //监听returnd
				// err:=mq.SendMessage(Lib.ROUTER_KEY_USERREG,Lib.EXCHANGE_USER,strconv.Itoa(userModel.UserId))
				err := mq.SendDelayMessage(Lib.ROUTER_KEY_USERREG, Lib.EXCHANGE_USER_DELAY, strconv.Itoa(userModel.UserId), 1000)
				mq.ListenConfirm()

				//  defer mq.Channel.Close()
				if err != nil {
					log.Println("发送消息失败", err)
				}

			}
			context.JSON(200, gin.H{"result": userModel})
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
		err := AppInit.DBInit()
		if err != nil {
			c <- err
		}
	}()
	go func() {
		err := Lib.UserInit() //初始化用户队列
		if err != nil {
			c <- err
		}
		err = Lib.UserDelayInit() //初始化用户延迟队列
		if err != nil {
			c <- err
		}

	}()
	err := <-c
	log.Fatal(err)

}
