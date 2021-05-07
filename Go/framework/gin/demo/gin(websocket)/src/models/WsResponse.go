package models

import "encoding/json"

//结构 自定义
type WsResponse struct {
	Type   string
	Result interface{}
}

func NewWsResponse(t string, result interface{}) *WsResponse {
	return &WsResponse{Type: t, Result: result}
}
func (this *WsResponse) ToJson() []byte {
	str, err := json.Marshal(this)
	if err != nil {
		return []byte("")
	}
	return str
}
