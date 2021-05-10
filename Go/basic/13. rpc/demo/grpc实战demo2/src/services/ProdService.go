package services

import (
	"context"
	"mygrpc/src/pbfiles"
)

type ProdService struct {
	pbfiles.UnimplementedProdServiceServer
}

func (*ProdService) GetProd(ctx context.Context, req *pbfiles.ProdRequest) (*pbfiles.ProdResponse, error) {
	rsp := &pbfiles.ProdResponse{
		Result: &pbfiles.ProdModel{Id: req.ProdId, Name: "test"},
	}
	return rsp, nil
}
func NewProdService() *ProdService {
	return &ProdService{}
}
