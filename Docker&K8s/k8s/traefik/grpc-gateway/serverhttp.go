package main

import (
	"context"
	"github.com/grpc-ecosystem/grpc-gateway/v2/runtime"
	"google.golang.org/grpc"
	"log"
	"mygrpc/pbfiles"
	"net/http"
)

func main() {
	gwmux:=runtime.NewServeMux()
	opt:=[]grpc.DialOption{grpc.WithInsecure()}
	err:=pbfiles.RegisterProdServiceHandlerFromEndpoint(context.Background(),gwmux,":8080",opt)
	if err != nil {
		log.Fatal(err)
	}
	httpServer:=&http.Server{
		Addr:":8081",
		Handler:gwmux,
	}
	err=httpServer.ListenAndServe()
	if err!=nil{
		log.Fatal(err)
	}




}