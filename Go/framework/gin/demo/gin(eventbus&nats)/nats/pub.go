package main

import (
	"fmt"
	"log"
	"mypro/models"
	"time"

	"github.com/nats-io/nats.go"
)

func main() {
	nat, _ := nats.Connect(nats.DefaultURL)
	defer nat.Close()
	//nat.Publish("users.add", models.NewUserModel("shenyi").Json())
	msg, err := nat.Request("users.add", models.NewUserModel("shenyi").Json(), time.Second*1)
	if err != nil {
		log.Fatal(err)
	}
	fmt.Println(models.ParseForUser(msg.Data))

}
