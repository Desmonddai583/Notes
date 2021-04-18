package services

import "fmt"

type OrderService struct {
	Version string
}

func NewOrderService() *OrderService {
	return &OrderService{Version: "1.0"}
}
func (this *OrderService) GetOrderInfo(uid int) {
	fmt.Println("获取用户ID=", uid, "的订单信息")
}
