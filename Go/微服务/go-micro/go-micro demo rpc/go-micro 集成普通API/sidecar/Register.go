package sidecar

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
)

type JSONRequest struct {
	Jsonrpc string
	Method  string
	Params  []*Service
	Id      int
}

func NewJSONRequest(service *Service, endpoint string) *JSONRequest {
	return &JSONRequest{Jsonrpc: "2.0", Method: endpoint, Params: []*Service{service}, Id: 1}
}

var RegistryURI = "http://localhost:8000"

func requestRegistry(jsonrequest *JSONRequest) error { //关键代码。用来请求注册器
	b, err := json.Marshal(jsonrequest)
	if err != nil {
		log.Fatal(err)
		return err
	}
	rsp, err := http.Post(RegistryURI, "application/json", bytes.NewReader(b))
	if err != nil {
		return err
	}
	defer rsp.Body.Close()
	res, err := ioutil.ReadAll(rsp.Body)
	if err != nil {
		return err
	}
	fmt.Println(string(res)) //打印出结果
	return nil
}

func UnRegService(service *Service) error {
	return requestRegistry(NewJSONRequest(service, "Registry.Deregister"))
}
func RegService(service *Service) error {
	return requestRegistry(NewJSONRequest(service, "Registry.Register"))
}
