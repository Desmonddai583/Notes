package util

import (
	"context"
	"fmt"
	"time"

	"github.com/coreos/etcd/clientv3"
)

type Service struct {
	client *clientv3.Client
}

func NewService() *Service {
	config := clientv3.Config{
		Endpoints:   []string{"192.168.29.135:23791", "192.168.29.135:23792"},
		DialTimeout: 10 * time.Second,
	}
	client, _ := clientv3.New(config)
	return &Service{client: client}
}

//注册服务
func (this *Service) RegService(id string, name string, address string) error {
	kv := clientv3.NewKV(this.client)
	key_prefix := "/services/"
	ctx := context.Background()

	lease := clientv3.NewLease(this.client)
	leaseRes, err := lease.Grant(ctx, 60) //设置租约
	if err != nil {
		return err
	}
	_, err = kv.Put(ctx, key_prefix+id+"/"+name, address, clientv3.WithLease(leaseRes.ID))
	if err != nil {
		return err
	}
	keepaliveRes, err := lease.KeepAlive(context.TODO(), leaseRes.ID)
	if err != nil {
		return err
	}
	go lisKeepAlive(keepaliveRes)
	return nil
}
func lisKeepAlive(keepaliveRes <-chan *clientv3.LeaseKeepAliveResponse) {
	for {
		select {
		case ret := <-keepaliveRes:
			if ret != nil {
				fmt.Println("续租成功", time.Now())
			}
		}
	}
}

//反注册服务
func (this *Service) UnregService(id string) error {
	kv := clientv3.NewKV(this.client)
	key_prefix := "/services/" + id
	_, err := kv.Delete(context.Background(), key_prefix, clientv3.WithPrefix())
	return err
}
