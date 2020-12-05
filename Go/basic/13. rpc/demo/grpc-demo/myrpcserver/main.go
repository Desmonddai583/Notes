package main

import (
	"net"
	"com.jtthink.net/pbfiles"
	"context"
	"google.golang.org/grpc"
)


//type ProdService struct {}
//
//func(this *ProdService) GetProdStock(req prod.ProdRequest,res *prod.ProdResponse) error  {
//	if req.ProdId==500 {
//		res.ProdStock=20
//	}else {
//		res.ProdStock=30
//	}
//	return  nil
//}
type ProdServiceImpl struct {}

func(this *ProdServiceImpl) GetProdStock(ctx context.Context, req *prod.ProdRequest) (*prod.ProdResponse, error)  {
	if req.ProdId==500{
		return &prod.ProdResponse{ProdStock:15},nil
	}else{
		return &prod.ProdResponse{ProdStock:25},nil
	}
}


func main(){

	lis,_:=net.Listen("tcp",":8082")
	//rpc.Register(new(ProdService))//注册对外暴露的方法
	//for{
	//	client,_:=lis.Accept() //很常规的socket 编程哦~~~
	//	rpc.ServeConn(client) //处理客户端连接
	//}

	myserver:=grpc.NewServer()
	prod.RegisterProdServiceServer(myserver,new(ProdServiceImpl))
	myserver.Serve(lis)





}
