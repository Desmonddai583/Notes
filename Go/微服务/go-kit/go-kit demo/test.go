package main

import (
	"fmt"
	"math/rand"
	"time"

	"github.com/afex/hystrix-go/hystrix"
)

type Product struct {
	ID    int
	Title string
	Price int
}

func getProduct() (Product, error) {
	r := rand.Intn(10)
	if r < 6 {
		time.Sleep(time.Second * 5)
	}
	time.Sleep(time.Second * 5)
	return Product{
		ID:    101,
		Title: "Golang从入门到精通",
		Price: 12,
	}, nil
}
func RecProduct() (Product, error) {
	return Product{
		ID:    999,
		Title: "推荐商品",
		Price: 120,
	}, nil
}

func main() {
	rand.Seed(time.Now().UnixNano())
	configA := hystrix.CommandConfig{
		Timeout:                2000,
		MaxConcurrentRequests:  5,
		RequestVolumeThreshold: 3,
		ErrorPercentThreshold:  20,
		SleepWindow:            int(time.Second * 100),
	}
	hystrix.ConfigureCommand("get_prod", configA)
	c, _, _ := hystrix.GetCircuit("get_prod")
	for i := 0; i < 100; i++ {
		errs := hystrix.Do("get_prod", func() error {
			p, _ := getProduct() //这里会随机延迟5秒
			fmt.Println(p)
			return nil
		}, func(e error) error {
			rcp, err := RecProduct()
			fmt.Println(rcp)
			return err
		})
		if errs != nil {
			fmt.Println(errs)
		}
		fmt.Println(c.IsOpen())
		fmt.Println(c.AllowRequest())
		time.Sleep(time.Second * 1)
	}

}
