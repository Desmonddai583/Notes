package services

import "fmt"

type UserService struct {
	Order *OrderService `inject:"-"`
}

func NewUserService() *UserService {
	return &UserService{}
}

func (this *UserService) GetUserInfo(uid int) {
	fmt.Println("获取用户ID=", uid, "的详细信息")
}
func (this *UserService) GetOrderInfo(uid int) {
	this.Order.GetOrderInfo(uid)
}
