package ServiceImpl

import (
	"context"
	"strconv"

	"serivces.jtthink.com/Services"
)

//测试方法
func newProd(id int32, pname string) *Services.ProdModel {
	return &Services.ProdModel{ProdID: id, ProdName: pname}
}

type ProdService struct {
}

func (*ProdService) GetProdsList(ctx context.Context, in *Services.ProdsRequest, res *Services.ProdListResponse) error {
	models := make([]*Services.ProdModel, 0)
	var i int32
	for i = 0; i < in.Size; i++ {
		models = append(models, newProd(100+i, "prodname"+strconv.Itoa(100+int(i))))
	}
	res.Data = models
	return nil
}
