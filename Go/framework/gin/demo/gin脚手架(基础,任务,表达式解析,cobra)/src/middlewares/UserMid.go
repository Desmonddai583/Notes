package middlewares

import (
	"github.com/gin-gonic/gin"
)

//这代表是用户中间件 ,我要去 “继承”Fairing这个接口
type UserMid struct {

}
func NewUserMid() *UserMid {
	return &UserMid{}
}
//这代表 在请求进来时，我们做点业务逻辑。 思考下，除了这个还能怎样？
//其实还能扩展很多控制 逻辑 ，后面再说
func(this *UserMid) OnRequest (ctx *gin.Context) error  {

     return nil
}
