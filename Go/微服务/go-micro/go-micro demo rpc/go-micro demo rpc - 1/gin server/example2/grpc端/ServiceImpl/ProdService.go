package ServiceImpl

import (
	"context"
	"fmt"
	"strconv"
	"time"

	"serivces.jtthink.com/Services"
)

//测试方法
func newProd(id int32, pname string) *Services.ProdModel {
	return &Services.ProdModel{ProdID: id, ProdName: pname}
}

type ProdService struct {
}

func (*ProdService) GetProdsList(ctx context.Context, in *Services.ProdsRequest, res *Services.ProdListResponse) error {
	time.Sleep(time.Second * 3)
	models := make([]*Services.ProdModel, 0)
	var i int32
	for i = 0; i < in.Size; i++ {
		models = append(models, newProd(100+i, "prodname"+strconv.Itoa(100+int(i))))
	}
	fmt.Println(models)
	res.Data = models
	return nil
}
func (*ProdService) GetProdDetail(ctx context.Context, req *Services.ProdsRequest, rsp *Services.ProdDetailResponse) error {
	rsp.Data = newProd(req.ProdId, "测试商品详细")
	return nil
}
