package main

import (
	"context"
	"log"
	"net/http"

	"github.com/grpc-ecosystem/grpc-gateway/runtime"
	"google.golang.org/grpc"
	"tools.jtthink.com/ServiceGW"
)

func main() {
	ctx := context.Background()
	ctx, cancel := context.WithCancel(ctx)
	defer cancel()
	gRpcEndPoint := "localhost:8001"
	mux := runtime.NewServeMux()
	opts := []grpc.DialOption{grpc.WithInsecure()}
	err := ServiceGW.RegisterTestServiceHandlerFromEndpoint(ctx, mux, gRpcEndPoint, opts)
	if err != nil {
		log.Fatal(err)
	}
	http.ListenAndServe(":9000", mux)

}
