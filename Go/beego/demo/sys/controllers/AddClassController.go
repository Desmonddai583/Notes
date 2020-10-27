package controllers

import (
	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
	"sys/models"
)

type ClassController struct {
	beego.Controller
}
var classTypes []models.ClassType

func (c *ClassController) Get() {
	// 获取用户名
	userName :=c.GetSession("userName")
	beego.Info(userName, "userName")
	c.Data["userName"] = userName

	// 获取班级列表
	o := orm.NewOrm()
	qs := o.QueryTable("ClassType")

	if _, err := qs.All(&classTypes); err == nil{
		c.Data["classTypes"] = classTypes
	}

	/*c.Layout 用于返回固定不变的网页模板*/
	c.Layout = "layout.html"
	/*c.TplName 用于返回需要变化的网页模板*/
	c.TplName = "cls.html"
}
func (c *ClassController) Post() {
	c.Layout = "layout.html"
	c.TplName = "cls.html"
	c.Data["classTypes"] = classTypes
	
	// 1.获取数据
	className := c.GetString("className")
	// 2.安全校验
	if className == ""{
		c.Data["nameError"] = "必须输入班级名称"
		return
	}
	// 3.创建需要插入的对象
	var classType models.ClassType
	classType.ClassName = className

	// 4.获取ORM对象
	o := orm.NewOrm()

	err := o.Read(&classType, "ClassName")
	if err == orm.ErrNoRows{
		if _, err := o.Insert(&classType); err !=nil{
			beego.Info("插入数据失败", err)
		}
	}else{
		c.Data["nameError"] = "班级已经存在"
		return
	}
	c.Redirect("/option/addClass", 302)
}
func (c *ClassController) DelClass()  {
	// 获取数据
	id, _ := c.GetInt("id")
	// 创建需要删除的模型
	var classType models.ClassType
	classType.Id = id
	// 获取ORM对象
	o := orm.NewOrm()
	err := o.Read(&classType, "Id")
	if err != orm.ErrNoRows{
		o.Delete(&classType)
	}
	c.Redirect("/option/addClass", 302)
}

