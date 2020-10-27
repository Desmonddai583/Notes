package routers

import (
	"github.com/astaxie/beego/context"
	"sys/controllers"
	"github.com/astaxie/beego"
)

func init() {
/*
pattern 路由规则，可以根据一定的规则进行路由，如果你全匹配可以用 *
position 执行 Filter 的地方，五个固定参数如下，分别表示不同的执行过程
	BeforeStatic 静态地址之前
	BeforeRouter 寻找路由之前
	BeforeExec 找到路由之后，开始执行相应的 Controller 之前
	AfterExec 执行完 Controller 逻辑之后执行的过滤器(路由对应的控制器执行完毕之后执行)
	FinishRouter 执行完逻辑之后执行的过滤器(路由对应的控制器执行完毕之后执行)
filter filter 函数 type FilterFunc func(*context.Context)
*/
	beego.InsertFilter("/option/*", beego.BeforeExec, FilterLogin)
    beego.Router("/option/stuList", &controllers.MainController{})
    beego.Router("/option/delStudent", &controllers.MainController{}, "get:Del")
    beego.Router("/option/editStudent", &controllers.EditController{})
    beego.Router("/option/addStudent", &controllers.AddStudentController{})
    beego.Router("/option/addClass", &controllers.ClassController{})
    beego.Router("/option/delClass", &controllers.ClassController{}, "get:DelClass")
    beego.Router("/login", &controllers.LoginController{})
    beego.Router("/logout", &controllers.LogoutController{})
    beego.Router("/register", &controllers.RegisterController{})
}

/*定义过滤器函数*/
var FilterLogin = func(ctx *context.Context) {
	userNmae := ctx.Input.Session("userName")
	if userNmae == nil {
		ctx.Redirect(302, "/login")
	}
}
