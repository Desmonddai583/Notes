package core

import (
	"encoding/json"
	"skill4/src/models"
)

// 前端消息
type WsMessage struct {
	MessageType int
	MessageData []byte //  一般是JSON格式
}

func NewWsMessage(messageType int, messageData []byte) *WsMessage {
	return &WsMessage{MessageType: messageType, MessageData: messageData}
}

//把 前端传过来的JSON 解析为  Command
func (this *WsMessage) parseForCmd() (*models.WsResponse, error) {
	cmd := &WsCommand{}
	err := json.Unmarshal(this.MessageData, cmd)
	if err != nil {
		return nil, err
	}
	return cmd.Parse() //正式解析前端内容

}
