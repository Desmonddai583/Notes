package controllers

import (
	"bytes"
	"encoding/gob"
	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
	"github.com/garyburd/redigo/redis"
	"math"
	"sys/models"
)

type MainController struct {
	beego.Controller
}

func (c *MainController) Get() {
	// 获取用户名
	userName :=c.GetSession("userName")
	beego.Info(userName, "userName")
	c.Data["userName"] = userName

	// 查询班级列表
	// 1.建立和Redis的链接
	conn, _ := redis.Dial("tcp", "127.0.0.1:6379")
	// 2.关闭连接
	defer conn.Close()
	// 3.查询班级列表
	// 3.1.去Redis中查询数据
	rep, err := conn.Do("get", "ClassTypes")
	if rep == nil || err != nil{
		beego.Info("从MySQL中获取")
		// 如果Redis中没有, 就从MySQL中获取
		o := orm.NewOrm()
		qs := o.QueryTable("ClassType")
		qs.All(&classTypes)

		// 将获取的数据存储到Redis中, 方便下次使用
		// 1.创建一个容器, 用于存储转换之后的二进制数据
		var buffer bytes.Buffer
		// 2.告诉Go语言, 将转换的数据存储到什么地方
		//   创建一个编码对象
		enc := gob.NewEncoder(&buffer) // 编码
		// 3.将pers的数据转换到buffer中
		enc.Encode(&classTypes)
		// 4.将转换之后的二进制数据存储到Redis中
		conn.Do("set", "ClassTypes", buffer.Bytes())

	}else{
		beego.Info("从Redis中获取")
		// 如果Redis中有, 就从Redis中获取

		// 3.2.将查询的数据转换为二进制
		res, _ := redis.Bytes(rep, err)
		// 3.3.创建解码对象
		dec := gob.NewDecoder(bytes.NewReader(res)) // 解码
		// 3.4.将二进制的数据解码到指定变量中
		dec.Decode(&classTypes)
	}
	c.Data["classTypes"] = classTypes
	c.Data["stuClass"] = ""

	// 查询数据
	o := orm.NewOrm()
	qs := o.QueryTable("Student")
	var students []models.Student
	// 每一页显示的条数
	pageSize := 2
	// 获取View传递过来需要显示的页码
	pageIndex, err := c.GetInt("pageIndex")
	if err != nil{
		// 如果没有传递页码, 默认就是第一页
		pageIndex = 1
	}
	// 动态计算起始位置
	start := (pageIndex - 1) * pageSize

	// 获取View提交过来的班级名称
	stuClass := c.GetString("stuClass")

	if stuClass == ""{
		// 和SQL一样可以指定从什么地方开始取, 取多少个
		// Limit(个数, 起始索引)
		qs.RelatedSel("ClassType").Limit(pageSize, start).All(&students)
	}else{
		// where ClassType.ClassName = stuClass
		qs.RelatedSel("ClassType").Filter("ClassType__ClassName", stuClass).All(&students)
	}

	c.Data["students"] = students
	// 依据当前的查询条件，返回结果行数
	totalCount, _ := qs.Count()
	c.Data["totalCount"] = totalCount
	// 动态计算总页数   总条数/每一页条数
	totalPages := math.Ceil(float64(totalCount) / float64(pageSize))
	c.Data["totalPages"] = int(totalPages)
	beego.Info("totalCount", totalCount)


	// 回传数据
	c.Data["pageIndex"] = pageIndex

	c.Layout = "layout.html"
	c.TplName = "list.html"
}

func (c *MainController) Del()  {
	c.Layout = "layout.html"
	c.TplName = "list.html"

	// 获取View传递过来的数据
	stuId, err := c.GetInt("stuId")
	if err != nil{
		return
	}

	// 获取ORM对象
	o := orm.NewOrm()
	var student models.Student
	student.Id = stuId
	if err := o.Read(&student, "Id"); err == nil{
		o.Delete(&student, "Id")
	}

	// 跳转到列表界面
	c.Redirect("/option/stuList", 302)
}
