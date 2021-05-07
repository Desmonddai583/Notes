package models

type IModel interface {
	ParseAction(action string) (*WsResponse, error)
}
