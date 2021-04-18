package main

import (
	"log"

	"github.com/casbin/casbin/v2"
)

func main() {

	e, _ := casbin.NewEnforcer("resources/model.conf", "resources/p.csv")

	ok, err := e.Enforce("shenyi", "/depts", "POST")
	if err == nil && ok {
		log.Println("shenyi,运行通过")
	}
	ok, err = e.Enforce("lisi", "/depts", "POST")
	if err == nil && ok {
		log.Println("lisi,运行通过")
	}

}
