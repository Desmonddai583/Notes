package serviceimpl

import (
	"context"
	"mygrpc/pbfiles"
)

type ProdServiceImpl struct {

}
func NewProdServiceImpl() *ProdServiceImpl {
	return &ProdServiceImpl{}
}
func(this *ProdServiceImpl) GetStock(ctx context.Context,req *pbfiles.ProdRequest) (ret *pbfiles.ProdStockResponse, err error){
	ret=&pbfiles.ProdStockResponse{}
	ret.ProdId=req.ProdId
	ret.ProdStock=101
	return
}

func(this *ProdServiceImpl) GetHotProds(ctx context.Context,req *pbfiles.HotProdRequest) (ret *pbfiles.HotProdResponse, err error){
	prods:= []*pbfiles.ProdModel{
		{Id:101,Name:"PHP入门到精通"},
		{Id:102,Name:"java入门到精通"},
	}
	ret=&pbfiles.HotProdResponse{Result:prods}
	return

}