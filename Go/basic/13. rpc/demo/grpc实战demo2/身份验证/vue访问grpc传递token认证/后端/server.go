package main

import (
	"context"
	"google.golang.org/grpc"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/credentials"
	"google.golang.org/grpc/metadata"
	"google.golang.org/grpc/status"
	"log"
	"mygrpc/src/pbfiles"
	"mygrpc/src/services"
	"net"
	"net/http"
)
func tokenValidate(token string) bool{
	req,_:=http.NewRequest("POST","http://localhost:9090/auth",nil)
	req.Header.Add("X-Forwarded-Token",token)
    rsp,err:=http.DefaultClient.Do(req)
    defer rsp.Body.Close()
    if err!=nil || rsp.StatusCode==401{
    	return false
	}
    return true



}
func checkToken(ctx context.Context, req interface{}, info *grpc.UnaryServerInfo, handler grpc.UnaryHandler) (resp interface{}, err error){
	if md,ok:=metadata.FromIncomingContext(ctx);!ok{
		return nil,status.Error(codes.Unauthenticated,"metadata error")
	}else{
		if tokenList,ok:=md["token"];ok && len(tokenList)>0{
			if !tokenValidate(tokenList[0]){
				return nil,status.Error(codes.Unauthenticated,"access deny")
			}
		}else{
			return nil,status.Error(codes.Unauthenticated,"token error")
		}
	}
	return handler(ctx,req )
}

func main() {
	creds, err := credentials.NewServerTLSFromFile("certs/server.pem",
		"certs/server.key")
	if err != nil {
		log.Fatal(err)
	}

	myserver:=grpc.NewServer(grpc.Creds(creds),grpc.UnaryInterceptor(checkToken))
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