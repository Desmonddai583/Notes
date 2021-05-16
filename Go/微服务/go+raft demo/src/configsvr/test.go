package main

import (
	"fmt"
	"goraft/src/configsvr"

	"github.com/golang/protobuf/proto"
)

func main() {
	set := configsvr.NewConfigSet("test", "test content")

	b, _ := proto.Marshal(set)

	test_set := &configsvr.ConfigSet{}
	proto.Unmarshal(b, test_set)

	fmt.Println(test_set)

}
