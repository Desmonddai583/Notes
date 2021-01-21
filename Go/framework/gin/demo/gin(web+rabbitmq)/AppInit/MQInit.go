package AppInit

import (
	"fmt"
	"log"

	"github.com/streadway/amqp"
)

var MQConn *amqp.Connection

func init() {
	dsn := fmt.Sprintf("amqp://%s:%s@%s:%d/", "shenyi", "123", "192.168.29.135", 5672)
	conn, err := amqp.Dial(dsn)
	if err != nil {
		log.Fatal(err)
	}
	MQConn = conn

}
func GetConn() *amqp.Connection {
	return MQConn
}
