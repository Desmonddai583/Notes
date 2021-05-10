package main

import (
	"context"
	"github.com/casbin/casbin/v2"
	"google.golang.org/grpc"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/credentials"
	"google.golang.org/grpc/metadata"
	"google.golang.org/grpc/status"
	"log"
	"mygrpc/src/pbfiles"
	"mygrpc/src/services"
	"net"
)
var E *casbin.Enforcer
func init() {
	e,err:= casbin.NewEnforcer("casbin/model.conf","casbin/p.csv")
	if err!=nil{
		log.Fatal(err)
	}
	E=e
}

func RBAC(ctx context.Context, req interface{}, info *grpc.UnaryServerInfo, handler grpc.UnaryHandler) (resp interface{}, err error){
	md,ok:=metadata.FromIncomingContext(ctx)
    if !ok{
    	return nil,status.Errorf(codes.Unavailable,"请求错误")
	}
	tokens:=md.Get("token")
	if len(tokens)!=1{
		return nil,status.Errorf(codes.Unauthenticated,"没有权限(token)")
	}
	b,err:=E.Enforce(tokens[0],info.FullMethod)
	if !b || err!=nil{
		return nil,status.Errorf(codes.Unauthenticated,"没有权限")
	}
	 return handler(ctx,req)

}

func main() {
	creds, err := credentials.NewServerTLSFromFile("certs/server.pem",
		"certs/server.key")
	if err != nil {
		log.Fatal(err)
	}

	myserver:=grpc.NewServer(grpc.Creds(creds),
		grpc.UnaryInterceptor(RBAC) )
	pbfiles.RegisterProdServiceServer(myserver,services.NewProdService())
	//监听8080
	lis,err:=net.Listen("tcp",":8081")
	if err!=nil{
		log.Fatal(err)
	}
	if err:=myserver.Serve(lis);err!=nil {
		log.Fatal(err)
	}

}