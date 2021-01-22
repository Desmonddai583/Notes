package main

import (
	"log"

	"github.com/gin-gonic/gin"
	"rmq.jtthink.com/Trans"
)

func main() {
	router := gin.Default()
	router.Handle("POST", "/", func(context *gin.Context) {
		tm := Trans.NewTransModel()
		err := context.BindJSON(&tm)
		if err != nil {
			context.JSON(200, gin.H{"result": err.Error()})
		} else {
			context.JSON(200, gin.H{"result": tm.String()})
		}
	})

	c := make(chan error)
	go func() {
		err := router.Run(":8081")
		if err != nil {
			c <- err
		}
	}()
	go func() {
		err := Trans.DBInit("b")
		if err != nil {
			c <- err
		}
	}()
	err := <-c
	log.Fatal(err)
}
