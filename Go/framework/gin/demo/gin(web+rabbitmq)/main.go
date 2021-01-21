package main

import (
	"fmt"
	"log"

	"github.com/streadway/amqp"
)

func main() {
	dsn := fmt.Sprintf("amqp://%s:%s@%s:%d/", "shenyi", "123", "192.168.29.135", 5672)
	conn, err := amqp.Dial(dsn)
	if err != nil {
		log.Fatal(err)
	}
	defer conn.Close()
	c, err := conn.Channel()
	if err != nil {
		log.Fatal(err)
	}
	defer c.Close()

	//队列创建成功
	queue, err := c.QueueDeclare("test", false, false, false, false, nil)
	if err != nil {
		log.Fatal(err)
	}
	err = c.Publish("", queue.Name, false, false,
		amqp.Publishing{
			ContentType: "text/plain",
			Body:        []byte("test002"),
		},
	)
	if err != nil {
		log.Fatal(err)
	}
	log.Println("发送消息成功")

}
