package core

import (
	"encoding/json"
	"fmt"
	"reflect"
	"skill4/src/models"
)

const (
	NewPOD     = 101 //新增POD
	PODLIST    = 102 //获取POD列表
	ClientPing = 999
)

var CommandModel = map[int]models.IModel{}

func init() {
	CommandModel[NewPOD] = (*models.PodModel)(nil)
	CommandModel[ClientPing] = (*models.PingModel)(nil)
	//CommandModel[PODLIST]=(*models.PodModel)(nil)// 思考题
}

type WsCommand struct {
	CmdType   int
	CmdData   map[string]interface{}
	CmdAction string
}

func (this *WsCommand) Parse() (*models.WsResponse, error) {
	if v, ok := CommandModel[this.CmdType]; ok {
		newObj := reflect.New(reflect.TypeOf(v).Elem()).Interface()
		b, _ := json.Marshal(this.CmdData)
		err := json.Unmarshal(b, newObj)
		if err != nil {
			return nil, err
		}
		return newObj.(models.IModel).ParseAction(this.CmdAction)
	}
	return nil, fmt.Errorf("error command")
}
