package classes

import (
	"fmt"
	"github.com/gin-gonic/gin"
	"mygin/src/goft"
	"mygin/src/models"
)
type UserClass struct { //这一步我们手写
		// *goft.GormAdapter  //注入Gorm,无需手动赋值
		*goft.XOrmAdapter  //注入XOrm,无需手动赋值
		Age *goft.Value `prefix:"user.age"`  // Value注解，用于读取配置文件。无需手动赋值
}
func NewUserClass() *UserClass {
	return &UserClass{}
}
func(this *UserClass) UserTest(ctx *gin.Context) string{
      return "测试"+this.Age.String()
}
func(this *UserClass) UserList(ctx *gin.Context) goft.Models{
	users:=[]*models.UserModel{
		 {UserId:101,UserName:"sheniy"},
		 {UserId:102,UserName:"zhangsan"},
	}
	return goft.MakeModels(users)
}
func(this *UserClass) UserDetail(ctx *gin.Context) goft.Model{
	user:=models.NewUserModel()
	err:=ctx.ShouldBindUri(user)
	goft.Error(err,"ID参数不合法")
	 has,err:=this.Table("users").
		Where("user_id=?",user.UserId).
		Get(user)
    if !has{
    	goft.Error(fmt.Errorf("没有该用户"))
	}
	return user
}
func(this *UserClass) Build(goft *goft.Goft){ //这个参数是关键， 我们把goft传进来
	goft.Handle("GET","/test",this.UserTest).
	     Handle("GET","/user/:id",this.UserDetail).
		 Handle("GET","/userlist",this.UserList)
}
func(this *UserClass)  Name() string {
	return "UserClass"
}
