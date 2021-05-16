package configsvr

import (
	"goraft/src/lib"
	"net/http"

	"github.com/gin-gonic/gin"
)

type RequestGet struct {
	DataId  string `form:"dataId" binding:"required,min=2"`
	Group   string `form:"group" binding:"required,min=2"`
	Version string `form:"version" binding:"required,min=2"`
}
type RequestPost struct {
	DataId  string `form:"dataId" binding:"required,min=2"`
	Group   string `form:"group" binding:"required,min=2"`
	Version string `form:"version" binding:"required,min=2"`
	Desc    string `form:"desc"`
	Content string `form:"content" binding:"required,min=2"`
}

func Cors() gin.HandlerFunc {
	return func(c *gin.Context) {
		method := c.Request.Method

		c.Header("Access-Control-Allow-Origin", "*")
		c.Header("Access-Control-Allow-Headers", "Content-Type,AccessToken,X-CSRF-Token, Authorization, Token")
		c.Header("Access-Control-Allow-Methods", "POST, GET, OPTIONS,DELETE")
		c.Header("Access-Control-Expose-Headers", "Content-Length, Access-Control-Allow-Origin, Access-Control-Allow-Headers, Content-Type")
		c.Header("Access-Control-Allow-Credentials", "true")

		//放行所有OPTIONS方法
		if method == "OPTIONS" {
			c.AbortWithStatus(http.StatusNoContent)
		}
		// 处理请求
		c.Next()
	}
}

//运行配置 服务
func ConfigHttp() *gin.Engine {
	r := gin.Default()
	r.Use(lib.CacheMiddleware(), Cors())
	g := r.Group("diamond-server")
	//获取配置
	getConfig(g)
	// 删除配置
	rmConfig(g)
	//插入配置
	updateConfig(g)
	getConfigList(g)

	return r
}
