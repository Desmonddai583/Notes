package plugins

import "net/http"

type NamePlugin struct{}

func NewNamePlugin() *NamePlugin {
	return &NamePlugin{}
}
func (this *NamePlugin) ServeHttp(req *http.Request, writer http.ResponseWriter) {
	writer.Header().Add("name", "zhangsan")
}
func (*NamePlugin) Name() string {
	return "AddHeader"
}
