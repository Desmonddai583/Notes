package main

import (
	"log"
	"net/http"
	"skill4/src/core"
	"skill4/src/handlers"
)

func main() {

	http.HandleFunc("/echo", handlers.Echo)

	http.HandleFunc("/sendall", func(w http.ResponseWriter, req *http.Request) {
		core.ClientMap.SendAllPods()
		w.Write([]byte("OK"))
	})
	err := http.ListenAndServe(":8080", nil)
	if err != nil {
		log.Fatal(err)
	}
}
