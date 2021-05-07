package core

import (
	"log"
	"skill4/src/models"
	"time"

	"github.com/gorilla/websocket"
)

type WsClient struct {
	conn      *websocket.Conn
	readChan  chan *WsMessage         //读队列 (chan)
	writeChan chan *models.WsResponse //写队列  --本课时新加
	closeChan chan byte               // 失败队列
}

func NewWsClient(conn *websocket.Conn) *WsClient {
	return &WsClient{conn: conn,
		readChan:  make(chan *WsMessage),
		writeChan: make(chan *models.WsResponse),
		closeChan: make(chan byte)}
}
func (this *WsClient) Ping(waittime time.Duration) {
	for {
		time.Sleep(waittime)
		err := this.conn.WriteMessage(websocket.TextMessage, []byte("ping"))
		if err != nil {
			ClientMap.Remove(this.conn)
			return
		}
	}
}
func (this *WsClient) ReadLoop() {
	for {
		t, data, err := this.conn.ReadMessage()
		if err != nil {
			this.conn.Close()
			ClientMap.Remove(this.conn)
			this.closeChan <- 1
			break
		}
		this.readChan <- NewWsMessage(t, data)
	}
}

//新增写Loop
func (this *WsClient) WriteLoop() {
loop:
	for {
		select {
		case msg := <-this.writeChan:
			if err := this.conn.WriteMessage(websocket.TextMessage, msg.ToJson()); err != nil {
				this.conn.Close()
				ClientMap.Remove(this.conn)
				this.closeChan <- 1
				break loop //停止循环
			}
		}
	}
}

func (this *WsClient) HandlerLoop() {
loop:
	for {
		select {
		case msg := <-this.readChan:
			// fmt.Println(string(msg.MessageData))
			rsp, err := msg.parseForCmd()
			if err != nil {
				log.Println(err)
			}
			if rsp != nil {
				//写入消息
				this.writeChan <- rsp
			}
		case <-this.closeChan:
			log.Println("已经关闭")
			break loop
		}
	}
}
