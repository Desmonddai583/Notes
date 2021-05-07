package handlers

import (
	"log"
	"net/http"
	"skill4/src/core"
)

func Echo(w http.ResponseWriter, req *http.Request) {
	client, err := core.Upgrader.Upgrade(w, req, nil) //升级
	if err != nil {
		log.Println(err)
	} else {
		core.ClientMap.Store(client)
	}
}
