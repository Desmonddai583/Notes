package models

import (
	"github.com/astaxie/beego/orm"
	_ "github.com/go-sql-driver/mysql"
	"time"
)

// 定义模型
type User struct {
	Id   int
	Name string
	PassWorld string
}
type ClassType struct {
	Id int `orm:"pk;auto"`
	ClassName string `orm:"size(50)"` //
	Students []*Student `orm:"reverse(many)"`
}

type Student struct {
	Id int `orm:"pk;auto"`
	StuName string `orm:"size(50)"`
	StuDesc string `orm:"size(150)"`
	StuImg string `orm:"size(150)"`
	AddTime time.Time `orm:"auto_now_add"`
	/*添加外键约束, 学生必须指定班级, 而且班级还必须存在*/
	ClassType *ClassType `orm:"rel(fk);on_delete(set_null);null"`
}
func init()  {
	// 1.注册数据库驱动类型
	orm.RegisterDriver("mysql", orm.DRMySQL)
	// 2.获取ORM连接对象
	// 参数1        数据库的别名，用来在 ORM 中切换数据库使用
	// 参数2        driverName
	// 参数3        对应的链接字符串
	orm.RegisterDataBase("default", "mysql", "root:root@tcp(127.0.0.1:3306)/itzb?charset=utf8")
	// 3.注册ORM模型
	// 注意点: 注册完模型并不会创建表
	orm.RegisterModel(new(User), new(ClassType), new(Student))
	// 4.根据注册的模型创建表
	// 第一个参数: 数据库的别名(在哪个数据库中创建)
	// 第二个参数: 是否强制更新(销毁过去的再重新创建)
	// 第三个参数: 是否显示创建SQL语句
	orm.RunSyncdb("default", false, true)
}