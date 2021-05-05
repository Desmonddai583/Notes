package main

import (
	"fmt"
	"log"
	"mypro/models"

	"github.com/nats-io/nats.go"
)

func main() {

	nat, _ := nats.Connect(nats.DefaultURL)
	defer nat.Close()

	_, _ = nat.Subscribe("users.add", func(msg *nats.Msg) {
		user, err := models.ParseForUser(msg.Data)
		if err != nil {
			log.Println(err)
		}
		user.UserId = 103
		fmt.Println(msg.Reply)
		nat.Publish(msg.Reply, user.Json())
	})

	select {}
}
