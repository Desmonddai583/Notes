package controllers

import (
	"github.com/astaxie/beego"
)

type LogoutController struct {
	beego.Controller
}
func (c *LogoutController) Get()  {
	// 删除session
	c.DelSession("userName")
	// 跳转到登录界面
	c.Redirect("/login", 302)
}
