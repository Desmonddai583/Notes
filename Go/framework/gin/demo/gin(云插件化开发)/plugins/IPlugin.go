package plugins

import (
	"net/http"
	"sync"
)

var Plugins sync.Map

func init() {
	Plugins.Store("NamePlugin", &NamePlugin{})
}

type IPlugin interface {
	ServeHttp(req *http.Request, writer http.ResponseWriter)
	Name() string
}
