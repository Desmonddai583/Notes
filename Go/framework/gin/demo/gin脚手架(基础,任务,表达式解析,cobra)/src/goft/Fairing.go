package goft

import "github.com/gin-gonic/gin"

//这是啥？
//很简单，这是用来规范 中间件代码和功能的 接口
// Fairing==整流罩。 用户保护卫星的
//用这个名字，听起来很有腔调， 我很喜欢
type Fairing interface {
   OnRequest(*gin.Context) error  //这个有啥用？  等下我们可以看到
}