package main

import (
	"net"
	"net/rpc"
	"com.jtthink.net/pbfiles"
)


type ProdService struct {}

func(this *ProdService) GetStock(req prod.ProdRequest,res *prod.ProdResponse) error  {
	if req.ProdId==500 {
		res.ProdStock=20
	}else {
		res.ProdStock=30
	}
	return  nil
}

func main(){

	lis,_:=net.Listen("tcp",":8082")
	rpc.Register(new(ProdService))//注册对外暴露的方法

	for{
		client,_:=lis.Accept() //很常规的socket 编程哦~~~
		rpc.ServeConn(client) //处理客户端连接
	}






}
