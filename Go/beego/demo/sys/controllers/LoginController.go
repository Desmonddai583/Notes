package controllers

import (
	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
	"sys/models"
)

type LoginController struct {
	beego.Controller
}

func (c *LoginController) Get() {
	// 获取cookie内容
	userName := c.Ctx.GetCookie("userName")
	if userName != ""{
		c.Data["userName"] = userName
		c.Data["checked"] = "checked"
	}
	c.TplName = "login.html"
}
func (c *LoginController) Post() {

	// 1.获取View传递过来的数据
	userName := c.GetString("username")
	userPwd := c.GetString("password")
	remember := c.GetString("remember")

	// 2.回传数据, 避免用户重新输入
	c.Data["userName"] = userName
	c.Data["userPwd"] = userPwd
	c.TplName = "login.html"
	if remember == ""{
		c.Data["checked"] = ""
	}else{
		beego.Info("回传选中状态")
		c.Data["checked"] = "checked"
	}

	// 3.安全校验
	if userName == ""{
		c.Data["nameError"] = "必须输入用户名"
		return
	}
	if userPwd == ""{
		c.Data["pwdError"] = "必须输入密码"
		return
	}

	// 3.校验用户数据是否正确
	// 3.1获取ORM对象
	o := orm.NewOrm()
	// 3.2创建需要查询的对象
	var user models.User
	user.Name = userName
	// 3.3查询
	if err := o.Read(&user, "name"); err != nil{
		c.Data["errMsg"] = "用户不存在"
		return
	}
	// 3.4判断密码是否匹配
	if user.PassWorld != userPwd{
		c.Data["errMsg"] = "密码不正确"
		return
	}

	// 在前端记住用户名(通过Cookie)
	if remember == ""{
		// 不记住用户名
		c.Ctx.SetCookie("userName", userName, -1)
	}else{
		// 记住用户名
		c.Ctx.SetCookie("userName", userName, 60 * 60)
	}

	// 在后端记住用户的登录状态(通过Session)
	// 注意点: 如果现在beego中使用session,必须给配置文件添加 sessionon=true
	c.SetSession("userName", userName)

	// 4.跳转到首页
	c.Redirect("/option/stuList", 302)
}

func (c *LoginController) Logout()  {
	// 删除session
	c.DelSession("userName")
	// 跳转到登录界面
	c.Redirect("/login", 302)
}
