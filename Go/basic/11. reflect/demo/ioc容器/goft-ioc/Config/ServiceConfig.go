package Config

import (
	"ioc/services"
	"log"
)

type ServiceConfig struct {
}

func NewServiceConfig() *ServiceConfig {
	return &ServiceConfig{}
}
func (this *ServiceConfig) OrderService() *services.OrderService {
	log.Println("初始化 orderservice")
	return services.NewOrderService()
}
