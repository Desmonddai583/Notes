package jtheader

import "net/http"

type AddHeader struct {
}

func New() http.Handler {
	return &AddHeader{}
}

func (this *AddHeader) ServeHTTP(writer http.ResponseWriter, req *http.Request) {
	writer.Header().Add("name", "abc")

}
