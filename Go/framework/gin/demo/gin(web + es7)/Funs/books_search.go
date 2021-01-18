package Funs

import (
	"log"

	"es.jtthink.com/AppInit"
	"es.jtthink.com/Models"
	"github.com/gin-gonic/gin"
	"github.com/olivere/elastic/v7"
)

func SearchBook(ctx *gin.Context) {
	searchModel := Models.NewSearchModel()
	err := ctx.BindJSON(searchModel)
	if err != nil {
		log.Println(err)
		ctx.JSON(400, gin.H{"error": err.Error()})
		return
	}
	qList := make([]elastic.Query, 0)
	//加入图书名搜索条件
	if searchModel.BookName != "" {
		machQuery := elastic.NewMatchQuery("BookName", searchModel.BookName)
		qList = append(qList, machQuery)
	}
	//加入出版社搜索条件
	if searchModel.BookPress != "" { //判断出版社
		pressQuery := elastic.NewTermQuery("BookPress", searchModel.BookPress)
		qList = append(qList, pressQuery)
	}
	//价格搜索范围
	if searchModel.BookPrice1Start > 0 || searchModel.BookPrice1End > 0 {
		priceRangeQuery := elastic.NewRangeQuery("BookPrice1")
		if searchModel.BookPrice1Start > 0 {
			priceRangeQuery.Gte(searchModel.BookPrice1Start)
		}
		if searchModel.BookPrice1End > 0 {
			priceRangeQuery.Lte(searchModel.BookPrice1End)
		}
		qList = append(qList, priceRangeQuery)
	}

	//处理排序
	sortList := make([]elastic.Sorter, 0)
	{
		if searchModel.OrderSet.Score {
			sortList = append(sortList, elastic.NewScoreSort().Desc())
		}
		if searchModel.OrderSet.PriceOrder == Models.OrderByPriceAsc { //从低到高
			sortList = append(sortList, elastic.NewFieldSort("BookPrice1").Asc())
		}
		if searchModel.OrderSet.PriceOrder == Models.OrderByPriceDesc { //从高到低
			sortList = append(sortList, elastic.NewFieldSort("BookPrice1").Desc())
		}
	}

	boolMustQuery := elastic.NewBoolQuery().Must(qList...)

	rsp, err := AppInit.GetEsClient().Search().Query(boolMustQuery).SortBy(sortList...).
		From((searchModel.Current - 1) * searchModel.Size).Size(searchModel.Size).
		Index("books").Do(ctx)
	log.Println(err)
	if err != nil {
		ctx.JSON(500, gin.H{"error": err})
	} else {
		ctx.JSON(200, gin.H{"result": MapToBooks(rsp), "metas": gin.H{"total": rsp.TotalHits()}})
	}
}
