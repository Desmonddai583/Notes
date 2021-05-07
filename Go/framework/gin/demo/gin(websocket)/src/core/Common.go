package core

import (
	"net/http"

	"github.com/gorilla/websocket"
)

var Upgrader websocket.Upgrader

func init() {
	Upgrader = websocket.Upgrader{
		CheckOrigin: func(r *http.Request) bool {
			return true
		},
	}
}
