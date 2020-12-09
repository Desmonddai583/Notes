package src

import (
	"log"
	"os"
	"os/signal"
)

var ServerSigChan chan os.Signal

func init()  {
	ServerSigChan=make(chan os.Signal)
}
func ShutDownServer(err error)  {
	log.Println(err)
	ServerSigChan<-os.Interrupt
}
func ServerNotify()  {
	signal.Notify(ServerSigChan,os.Interrupt)
	<-ServerSigChan
}
