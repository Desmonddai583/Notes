package Funs

import (
	"fmt"

	"es.jtthink.com/AppInit"
	"es.jtthink.com/Middlewares"
	"github.com/gin-gonic/gin"
	"github.com/olivere/elastic"
)

type AggFunc func(field string) elastic.Aggregation

var app_map = map[string]AggFunc{
	"max": func(field string) elastic.Aggregation {
		return elastic.NewMaxAggregation().Field(field)
	},
}

const logIndexName = "bookslogs"

func LogAgg(ctx *gin.Context) {
	getType := ctx.Param("type")
	getFild := ctx.Param("field")

	if f, ok := app_map[getType]; ok {
		agg_name := fmt.Sprintf("%s_%s", getType, getFild)
		rsp, err := AppInit.GetEsClient().Search().Aggregation(agg_name, f(getFild)).
			Index(logIndexName).Do(ctx)
		Middlewares.CheckError(err, "agg request error")
		ctx.JSON(200, gin.H{"result": rsp.Aggregations})
	} else {
		Middlewares.CheckError(fmt.Errorf("agg type error"), "")
	}
}
