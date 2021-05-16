package configsvr

import (
	"fmt"
	"goraft/src/lib"

	"github.com/gin-gonic/gin"
)

const (
	URL_BASESTONE = "/basestone.do"
	URL_CONFIGCO  = "/config.co"
)

func getConfig(g *gin.RouterGroup) {
	g.Handle("GET", URL_CONFIGCO, func(context *gin.Context) {
		req := &RequestGet{}
		lib.Error(context.BindQuery(req))
		cs := NewConfigService(req.Group, req.DataId, req.Version, nil)
		lib.Error(cs.Load())
		context.JSON(200, cs.Config)
	})
}
func rmConfig(g *gin.RouterGroup) {
	g.Handle("DELETE", URL_CONFIGCO, func(context *gin.Context) {
		req := &RequestGet{}
		lib.Error(context.BindQuery(req))
		cs := NewConfigService(req.Group, req.DataId, req.Version, nil)
		lib.Error(cs.Remove())
		context.JSON(200, gin.H{"message": "Ok"})
	})
}
func updateConfig(g *gin.RouterGroup) {
	g.Handle("POST", URL_BASESTONE, func(context *gin.Context) {
		req := &RequestPost{}
		lib.Error(context.Bind(req))
		fmt.Println(req)
		set := NewConfigSet(req.Desc, req.Content)
		cs := NewConfigService(req.Group, req.DataId, req.Version, set)
		lib.Error(cs.Save())
		context.JSON(200, gin.H{"message": "Ok"})
	})
}
func getConfigList(g *gin.RouterGroup) {
	g.Handle("GET", URL_BASESTONE, func(context *gin.Context) {
		//  /group/dataId/version xxx
		if context.Query("method") == "groups" { // 加载 分组列表
			context.JSON(200, gin.H{"result": LoadGroups()})
		} else {
			//加载全部配置列表
			cfgList := LoadAllConfig()
			context.JSON(200, gin.H{"result": cfgList})
		}

	})
}
