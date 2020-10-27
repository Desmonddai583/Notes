package controllers

import (
	"fmt"
	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
	"path"
	"sys/models"
	"time"
)

type AddStudentController struct {
	beego.Controller
}
//var classTypes []models.ClassType

func (c *AddStudentController) Get() {
	// 获取用户名
	userName :=c.GetSession("userName")
	beego.Info(userName, "userName")
	c.Data["userName"] = userName
	c.Data["stuClass"] = ""

	// 获取班级列表
	o := orm.NewOrm()
	qs := o.QueryTable("ClassType")

	if _, err := qs.All(&classTypes); err == nil{
		c.Data["classTypes"] = classTypes
	}
	c.Layout="layout.html"
	c.TplName = "stu.html"
}
func (c *AddStudentController) Post()  {
	c.Layout="layout.html"
	c.TplName = "stu.html"
	c.Data["classTypes"] = classTypes

	// 1.获取View传递过来的数据
	stuName := c.GetString("stuName")
	stuDesc := c.GetString("stuDesc")
	stuClass := c.GetString("stuClass")
	file, hand, imgErr := c.GetFile("stuIcon")

	c.Data["stuName"] = stuName
	c.Data["stuDesc"] = stuDesc
	c.Data["stuClass"] = stuClass
	beego.Info("stuClass=", stuClass)

	if stuName == ""{
		c.Data["nameError"] = "必须指定学员名称"
		return
	}
	if stuDesc == ""{
		c.Data["descError"] = "必须指定学员简介"
		return
	}
	if stuClass == ""{
		c.Data["classError"] = "必须指定学员班级"
		return
	}
	if imgErr != nil{
		c.Data["imgError"] = "必须指定学员头像"
		return
	}
	// 校验图片的大小
	if hand.Size > 1024 * 1024 * 5{
		c.Data["imgError"] = "图片太大了"
		return
	}
	// 检验图片类型
	if path.Ext(hand.Filename) != ".jpg" && path.Ext(hand.Filename) != ".png"{
		c.Data["imgError"] = "只支持jpg/png格式的图片"
		return
	}
	defer file.Close()

	fileName := time.Now().Format("2006-01-02-15-04-05-") + hand.Filename
	path := fmt.Sprint("./static/img/",fileName)
	beego.Info(path)
	err := c.SaveToFile("stuIcon", path)
	if err != nil{
		beego.Error("保存图片失败", err)
	}

	// 获取班级对象
	var classType models.ClassType
	classType.ClassName = stuClass
	beego.Info(classType, "classType 111")
	o := orm.NewOrm()
	o.Read(&classType, "ClassName")
	beego.Info(classType, "classType 222")
	// 将数据插入到数据库中

	var student models.Student
	student.StuName = stuName
	student.StuDesc = stuDesc
	student.StuImg = fmt.Sprint("/static/img/",fileName)
	student.ClassType = &classType
	o.Insert(&student)

	c.Redirect("/option/addStudent", 302)
}
