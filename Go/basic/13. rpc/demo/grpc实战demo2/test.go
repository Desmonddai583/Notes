package main

import (
	"fmt"
	"io/ioutil"
	"log"

	"github.com/golang/protobuf/proto"
	"google.golang.org/protobuf/types/descriptorpb"
)

func main() {

	b, err := ioutil.ReadFile("prod.pb")
	if err != nil {
		log.Fatal(err)
	}
	fds := &descriptorpb.FileDescriptorSet{}
	err = proto.Unmarshal(b, fds)
	if err != nil {
		log.Fatal(err)
	}
	for _, f := range fds.File {
		fmt.Println(*f.Name, f.Options.GetGoPackage())
		for _, svc := range f.Service {
			fmt.Println(*svc.Name)
			for _, m := range svc.Method {
				fmt.Println(*m.Name)
			}
		}
	}

}
