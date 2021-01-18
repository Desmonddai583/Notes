package Funs

import (
	"reflect"
	"strings"

	"es.jtthink.com/AppInit"
	"es.jtthink.com/Models"
	"github.com/gin-gonic/gin"
	"github.com/olivere/elastic/v7"
)

func MapToBooks(rsp *elastic.SearchResult) []*Models.Books {
	ret := []*Models.Books{}
	var t *Models.Books
	for _, item := range rsp.Each(reflect.TypeOf(t)) {
		ret = append(ret, item.(*Models.Books))
	}
	return ret
}
func LoadBook(ctx *gin.Context) {
	rsp, err := AppInit.GetEsClient().Search().Index("books").Do(ctx)
	if err != nil {
		ctx.JSON(500, gin.H{"error": err})
	} else {
		ctx.JSON(200, gin.H{"result": MapToBooks(rsp)})
	}
}
func LoadBookByPress(ctx *gin.Context) {
	press, _ := ctx.Params.Get("press")
	list := strings.Split(press, ",")
	pressList := []interface{}{}
	for _, p := range list {
		pressList = append(pressList, p)
	}

	termQuery := elastic.NewTermsQuery("BookPress", pressList...)
	machQuery := elastic.NewMatchQuery("BookName", "图灵")
	b := elastic.NewBoolQuery().
		Must(termQuery, machQuery)
	rsp, err := AppInit.GetEsClient().Search().Query(b).
		Index("books").Do(ctx)
	if err != nil {
		ctx.JSON(500, gin.H{"error": err})
	} else {
		ctx.JSON(200, gin.H{"result": MapToBooks(rsp)})
	}
}
