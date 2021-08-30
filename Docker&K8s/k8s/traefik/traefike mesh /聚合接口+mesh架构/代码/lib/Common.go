package lib

import (
	"github.com/nats-io/nats.go"
	"log"
	"os"
)
var NATSURL="nats://39.105.28.235:14222"

func init() {
	if os.Getenv("NATSURL")!=""{ //环境变量
		NATSURL=os.Getenv("NATSURL")
	}
}
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
	nat,err:=nats.Connect(NATSURL)
	if err!=nil{
		log.Fatal(err)
	}
	Broker=nat
}

