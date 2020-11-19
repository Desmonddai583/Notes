package controllers

import (
	"fmt"
	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
	"sys/models"
	"time"
	"path"
)

type EditController struct {
	beego.Controller
}
var student models.Student
func (c *EditController) Get() {
	c.Layout = "layout.html"
	c.TplName = "edit.html"

	// 1.获取用户名
	userName :=c.GetSession("userName")
	c.Data["userName"] = userName

	// 2.查询班级列表
	o := orm.NewOrm()
	qs := o.QueryTable("ClassType")
	if _, err := qs.All(&classTypes); err == nil{
		c.Data["classTypes"] = classTypes
	}

	// 3.获取需要编辑的学生ID
	stuId, err := c.GetInt("stuId")
	if err != nil{
		return
	}

	// 4.获取需要编辑的学生对象
	student.Id = stuId
	// 注意点: ORM为了提升性能, 默认情况下只会查询指定的表, 不会做关联查询
	//if err := o.Read(&student, "Id"); err != nil{
	//	return
	//}

	// 注意点: 如果想获取关联表中的数据, 那么必须通过RelatedSel指定需要查询的关联的那张表
	qs = o.QueryTable("Student")
	qs.Filter("Id", &student).RelatedSel("ClassType").One(&student)
	//beego.Info("student====", student.ClassType.ClassName)

	// 4.将需要编辑的数据回传给View
	c.Data["stuName"] = student.StuName
	c.Data["stuDesc"] = student.StuDesc
	c.Data["stuClass"] = student.ClassType.ClassName
}

func (c *EditController) Post(){
	c.Layout = "layout.html"
	c.TplName = "edit.html"
	c.Data["classTypes"] = classTypes

	// 1.获取View传递过来的数据
	stuName := c.GetString("stuName")
	stuDesc := c.GetString("stuDesc")
	stuClass := c.GetString("stuClass")
	file, hand, imgErr := c.GetFile("stuIcon")

	// 回传数据
	c.Data["stuName"] = stuName
	c.Data["stuDesc"] = stuDesc
	c.Data["stuClass"] = stuClass

	// 安全校验
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

	// 默认使用以前的头像
	iconPath := student.StuImg
	// 如果重新上传了图片, 就使用新上传的头像
	if imgErr == nil{
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
		fileName := time.Now().Format("2006-01-02-15-04-05-") + hand.Filename
		iconPath = fmt.Sprint("./static/img/",fileName)

		err := c.SaveToFile("stuIcon", iconPath)
		if err != nil{
			beego.Error("保存图片失败", err)
		}
		iconPath = fmt.Sprint("/static/img/",fileName)
		// 只有上传了图片,file才有值, 才能关闭
		defer file.Close()
	}


	// 获取班级对象
	var classType models.ClassType
	classType.ClassName = stuClass
	o := orm.NewOrm()
	o.Read(&classType, "ClassName")

	if err := o.Read(&student, "Id"); err == nil{
		// 将数据插入到数据库中
		student.StuName = stuName
		student.StuDesc = stuDesc
		student.StuImg = iconPath
		student.ClassType = &classType
		num, err := o.Update(&student)
		if err != nil{
			beego.Info("更新失败", err)
		}
		beego.Info("num", num)
	}
	c.Redirect("/option/stuList", 302)
}
/*
1,在列表界面将需要编辑的学生ID传递过来
2.在编辑界面的Get方法中
2.1在编辑界面根据学生ID找到学生生成学生模型
2.2将学生模型传递给编辑界面, 显示需要编辑的数据
3.在编辑界面的Post方法中
3.1获取编辑之后的数据
3.2安全校验并且回传已经添加的信息
3.3对头像进行特殊处理
3.3.1没有传递新的头像, 就使用以前的头像
3.3.2传递了新的头像, 就使用新的头像
3.4查询需要编辑的学生, 修改学生编辑之后的数据
3.5通过ORM更新数据库中对应的模型
*/
