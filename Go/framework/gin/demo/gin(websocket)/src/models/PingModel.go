package models

type PingModel struct {
}

func (this *PingModel) ParseAction(action string) (*WsResponse, error) {
	return NewWsResponse("PingModel", "pong"), nil
}
