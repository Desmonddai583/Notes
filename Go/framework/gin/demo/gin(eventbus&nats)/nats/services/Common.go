package services

import (
	"github.com/nats-io/nats.go"
	"log"
	"eventbus/eventbus"
)
var Broker *nats.Conn
var JSONBroker *nats.EncodedConn  // 带编码的connection
func InitJSONBroker(){
	InitBroker()
	jsonconn,err:=nats.NewEncodedConn(Broker,nats.JSON_ENCODER)
	if err!=nil{
		log.Fatal(err)
	}
	JSONBroker=jsonconn
}
func InitBroker() {
	nat,err:=nats.Connect(nats.DefaultURL)
	if err!=nil{
		log.Fatal(err)
	}
	Broker=nat
}
const GetList_Prods="GetProdList"
var Bus *eventbus.EventBus

func init() {
	Bus=eventbus.NewEventBus()
}
