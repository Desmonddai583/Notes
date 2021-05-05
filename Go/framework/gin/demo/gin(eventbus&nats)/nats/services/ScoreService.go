package services

import "context"

type ScoreService struct {}
func(this *ScoreService) GetScore(ctx context.Context,req *ScoreRequest) ( *ScoreResponse,  error){
		 rsp:=&ScoreResponse{}
		 rsp.Score=211
		 return rsp,nil
}