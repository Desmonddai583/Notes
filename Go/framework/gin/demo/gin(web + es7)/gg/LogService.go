package gg

import (
	"context"
	"reflect"

	"es.jtthink.com/AppInit"
	"github.com/olivere/elastic/v7"
)

func MapToLogs(rsp *elastic.SearchResult) []*LogModel {
	ret := []*LogModel{}
	var t *LogModel
	for _, item := range rsp.Each(reflect.TypeOf(t)) {
		ret = append(ret, item.(*LogModel))
	}
	return ret
}

type LogService struct {
	queryList []elastic.Query
	size      int //显示的条数
}

func NewLogService() *LogService {
	return &LogService{make([]elastic.Query, 0), 10}
}
func (this *LogService) WithUrlQuery(url interface{}) *LogService {
	if url != nil {
		urlQuery := elastic.NewWildcardQuery("url.keyword", url.(string))
		this.queryList = append(this.queryList, urlQuery)
	}
	return this
}
func (this *LogService) WithMethodQuery(method interface{}) *LogService {
	if method != nil {
		methodQuery := elastic.NewWildcardQuery("method", method.(string))
		this.queryList = append(this.queryList, methodQuery)
	}
	return this
}
func (this *LogService) WithSize(size interface{}) *LogService {
	if size != nil {
		this.size = size.(int)
	}
	return this
}
func (this *LogService) Search() ([]*LogModel, error) {

	boolMustQuery := elastic.NewBoolQuery().Must(this.queryList...)
	rsp, err := AppInit.GetEsClient().Search().Index("bookslogs").
		Query(boolMustQuery).Size(this.size).
		Do(context.Background())

	return MapToLogs(rsp), err
}
