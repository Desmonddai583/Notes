package main

import (
	"context"
	"crypto/tls"
	"crypto/x509"
	"fmt"
	"io/ioutil"
	"log"
	"mygrpc/src/pbfiles"

	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials"
)

func main() {
	cert, _ := tls.LoadX509KeyPair("certs/client.crt", "certs/client.key")
	certPool := x509.NewCertPool()
	ca, _ := ioutil.ReadFile("certs/ca.crt")
	certPool.AppendCertsFromPEM(ca)

	creds := credentials.NewTLS(&tls.Config{
		Certificates: []tls.Certificate{cert}, //客户端证书
		ServerName:   "test.grpc.jtthink.com",
		RootCAs:      certPool,
	})

	client, err := grpc.DialContext(context.Background(),
		"test.grpc.jtthink.com:8081",
		grpc.WithTransportCredentials(creds),
		grpc.WithPerRPCCredentials(lib.NewAuth("123123")),
	)

	if err != nil {
		log.Fatal(err)
	}
	req := &pbfiles.ProdRequest{ProdId: 123}
	rsp := &pbfiles.ProdResponse{}
	err = client.Invoke(context.Background(),
		"/ProdService/GetProd", req, rsp)
	if err != nil {
		log.Fatal(err)
	}
	fmt.Println(rsp.Result)

}
