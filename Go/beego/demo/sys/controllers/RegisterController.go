package controllers

import (
	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
	"sys/models"
)

type RegisterController struct {
	beego.Controller
}

func (c *RegisterController) Get() {

	c.TplName = "register.html"
}

func (c *RegisterController)  Post(){
	// 1.获取View传递过来的数据
	userName := c.GetString("username")
	userPwd := c.GetString("password")

	// 2.回传数据
	c.Data["userName"] = userName
	c.Data["userPwd"] = userPwd
	c.TplName = "register.html"

	// 3.对数据进行校验
	if len(userName) < 2{
		c.Data["nameError"] = "用户名必须大于等于2位"
		return
	}
	if len(userPwd) < 6{
		c.Data["pwdError"] = "密码必须大于等于6位"
		return
	}

	// 4.将数据插入到数据库中
	// 4.0获取ORM对象
	o := orm.NewOrm()
	// 4.1创建需要查询的对象
	var user models.User
	user.Name = userName
	// 4.2查询用户名是否被占用
	err := o.Read(&user, "name")
	if err != orm.ErrNoRows{
		c.Data["errMsg"] = "用户名被占用"
		return
	}
	// 4.3将用户插入到表中
	user.PassWorld = userPwd
	if _, err := o.Insert(&user); err != nil{
		c.Data["errMsg"] = "注册失败, 请稍后再试"
	}else{
		// 跳转到登录界面
		c.Redirect("/", 302)
	}
}