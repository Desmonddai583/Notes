package main

import (
	"context"
	"log"

	"github.com/coreos/etcd/clientv3"

	"time"
)

func main() {
	cli, err := clientv3.New(clientv3.Config{
		Endpoints:   []string{"39.105.28.235:32379"},
		DialTimeout: 5 * time.Second,
	})
	if err != nil {
		log.Fatal(err)
	}
	defer cli.Close()
	kv := clientv3.NewKV(cli)
	ctx := context.Background()
	_, err = kv.Put(ctx, "/service/test", "testservice")
	if err != nil {
		log.Fatal(err)
	}

}
