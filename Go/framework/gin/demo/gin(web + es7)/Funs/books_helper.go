package Funs

import (
	"es.jtthink.com/AppInit"
	"github.com/gin-gonic/gin"
	"github.com/olivere/elastic/v7"
)

func MapFiledsToSlice(rsp *elastic.SearchResult, key string) []interface{} {
	ret := make([]interface{}, 0)
	for _, hit := range rsp.Hits.Hits {
		ret = append(ret, hit.Fields[key].([]interface{})[0])
	}
	return ret
}

//无脑取前10个出版社
func PressList(ctx *gin.Context) {
	cb := elastic.NewCollapseBuilder("BookPress")
	rsp, err := AppInit.GetEsClient().Search().Collapse(cb).FetchSource(false).
		Index("books").Size(20).Do(ctx)

	if err != nil {
		ctx.JSON(500, gin.H{"error": err})
	} else {
		ctx.JSON(200, gin.H{"result": MapFiledsToSlice(rsp, "BookPress")})
	}
}
