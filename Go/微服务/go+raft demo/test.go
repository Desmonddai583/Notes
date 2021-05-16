package main

import (
	"fmt"
	"goraft/src/lib"
	"log"
	"time"
)

func main() {
	cache := lib.NewBcache("tmp")
	defer cache.Close()
	for i := 0; i < 10; i++ {
		err := cache.SetItemWithTTl(fmt.Sprintf("key%d", i), fmt.Sprintf("value%d", i), time.Second*10)
		if err != nil {
			log.Println(err)
		} else {
			time.Sleep(time.Millisecond * 500)
			log.Println("key", i, "设置成功")
		}
	}
	for i := 0; i < 20; i++ {
		fmt.Println(cache.Keys(20))
		time.Sleep(time.Second * 1)
	}

}
