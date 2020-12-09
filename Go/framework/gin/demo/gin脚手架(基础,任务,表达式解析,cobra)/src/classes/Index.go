package classes

import (
	"github.com/gin-gonic/gin"
	"mygin/src/goft"
)

type IndexClass struct {
}
func NewIndexClass() *IndexClass {
	return &IndexClass{}
}
func(this *IndexClass) GetIndex(ctx *gin.Context) goft.View {
	ctx.Set("name","zhangsan")
	 return "index"
}
func(this *IndexClass) Build(goft *goft.Goft){
	goft.Handle("GET","/",this.GetIndex)
}

func(this *IndexClass)  Name() string {
	return "IndexClass"
}
