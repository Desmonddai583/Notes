package core

import (
	"log"
	"skill4/src/models"
	"sync"
	"time"

	"github.com/gorilla/websocket"
)

//外部公共使用
var ClientMap *ClientMapStruct

func init() {
	ClientMap = &ClientMapStruct{}
}

type ClientMapStruct struct {
	data sync.Map //  key 是客户端IP  value 就是 WsClient连接对象
}

func (this *ClientMapStruct) Store(conn *websocket.Conn) {
	wsClient := NewWsClient(conn)
	this.data.Store(conn.RemoteAddr().String(), wsClient)
	go wsClient.Ping(time.Second * 1)
	go wsClient.WriteLoop()   //独立写循环
	go wsClient.ReadLoop()    //处理读 循环
	go wsClient.HandlerLoop() //处理 总控制循环

}

//向所有客户端 发送消息
func (this *ClientMapStruct) SendAllPods() {
	this.data.Range(func(key, value interface{}) bool {
		c := value.(*WsClient).conn
		//err:=c.WriteMessage(websocket.TextMessage,[]byte(msg))
		err := c.WriteJSON(models.MockPodeList())
		if err != nil {
			this.Remove(c)
			log.Println(err)
		}
		return true
	})
}
func (this *ClientMapStruct) Remove(conn *websocket.Conn) {
	this.data.Delete(conn.RemoteAddr().String())
}
