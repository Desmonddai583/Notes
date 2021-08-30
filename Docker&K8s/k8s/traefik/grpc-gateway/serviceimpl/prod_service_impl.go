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
func(this *ProdServiceImpl) GetStock(context.Context, *pbfiles.ProdRequest) (ret *pbfiles.ProdStockResponse, err error){
	ret=&pbfiles.ProdStockResponse{}
	ret.ProdStock=101
	return
}
