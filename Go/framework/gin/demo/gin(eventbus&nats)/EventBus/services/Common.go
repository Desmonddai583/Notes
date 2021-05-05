package services

import "mypro/eventbus"

const GetList_Prods = "GetProdList"

var Bus *eventbus.EventBus

func init() {
	Bus = eventbus.NewEventBus()
}
