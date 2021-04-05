package main

import (
	"log"

	"service.jtthink.com/util"
)

func main() {
	err := util.GenRSAPubAndPri(1024, "./pem")
	if err != nil {
		log.Fatal(err)
	}
}
