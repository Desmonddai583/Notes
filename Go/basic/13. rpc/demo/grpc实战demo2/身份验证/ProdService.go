package services

import (
	"context"
	"fmt"
	"mygrpc/src/pbfiles"
	"time"

	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/metadata"
	"google.golang.org/grpc/status"
)

type ProdService struct {
	pbfiles.UnimplementedProdServiceServer
}

func NewProdService() *ProdService {
	return &ProdService{}
}
func (*ProdService) GetProd(ctx context.Context, req *pbfiles.ProdRequest) (*pbfiles.ProdResponse, error) {

	if md, ok := metadata.FromIncomingContext(ctx); !ok {
		return nil, status.Error(codes.Unauthenticated, "metadata error")
	} else {
		if tokenList, ok := md["token"]; ok {
			fmt.Println(tokenList[0])
		} else {
			return nil, status.Error(codes.Unauthenticated, "token error")

		}
	}
	if err := req.Validate(); err != nil {
		return nil, err
	}
	rsp := &pbfiles.ProdResponse{
		Result: &pbfiles.ProdModel{Id: req.ProdId, Name: "test"},
	}
	return rsp, nil
}
func (*ProdService) GetProd_Stream(req *pbfiles.ProdRequest, rsp pbfiles.ProdService_GetProd_StreamServer) error {
	for i := 0; i < 5; i++ {
		err := rsp.Send(&pbfiles.ProdResponse{
			Result: &pbfiles.ProdModel{Id: int32(i + 100), Name: "test"},
		})
		if err != nil {
			return err
		}
		time.Sleep(time.Second)
	}
	return nil

}
