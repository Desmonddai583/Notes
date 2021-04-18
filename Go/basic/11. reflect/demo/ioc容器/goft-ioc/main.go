package main

import (
	"fmt"
	"ioc/Config"
	. "ioc/Injector"
	"ioc/services"
)

func main() {
	serviceConfig := Config.NewServiceConfig()

	BeanFactory.Config(serviceConfig) //展开方法
	//  BeanFactory.Set()
	{
		//这里 测试 userService
		userService := services.NewUserService()
		BeanFactory.Apply(userService)
		fmt.Println(userService.Order)
	}
	{
		//这里 测试 adminService
		adminService := services.NewAdminService()
		BeanFactory.Apply(adminService)
		fmt.Println(adminService.Order)
	}

}
