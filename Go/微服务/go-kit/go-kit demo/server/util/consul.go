package util

import (
	"fmt"
	"log"

	"github.com/google/uuid"
	consulapi "github.com/hashicorp/consul/api"
)

var ConsulClient *consulapi.Client
var ServiceID string
var ServiceName string
var ServicePort int

func init() { //引入包时自动执行
	config := consulapi.DefaultConfig()
	config.Address = "192.168.29.128:8500"
	client, err := consulapi.NewClient(config)
	if err != nil {
		log.Fatal(err)
	}
	ConsulClient = client
	ServiceID = "userservice" + uuid.New().String()
}
func SetServiceNameAndPort(name string, port int) {
	ServiceName = name
	ServicePort = port
}

func RegService() {
	reg := consulapi.AgentServiceRegistration{}
	reg.ID = ServiceID
	reg.Address = "192.168.29.1"
	reg.Name = ServiceName
	reg.Port = ServicePort
	reg.Tags = []string{"primary"}

	check := consulapi.AgentServiceCheck{}
	check.Interval = "5s"
	//上节课的一个Bug
	//check.HTTP="http://192.168.29.1:8080/health"
	check.HTTP = fmt.Sprintf("http://%s:%d/health", reg.Address, ServicePort)

	reg.Check = &check

	err := ConsulClient.Agent().ServiceRegister(&reg)
	if err != nil {
		log.Fatal(err)
	}

}
func Unregservice() {
	ConsulClient.Agent().ServiceDeregister(ServiceID)

}
