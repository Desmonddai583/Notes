protoc:
  用于protobuf编译生成工具
  https://github.com/protocolbuffers/protobuf

安装protobuf库 （go版本）
  https://github.com/golang/protobuf
  go get -u github.com/golang/protobuf@v1.5.2

创建一个proto文件
  syntax = "proto3";
  option go_package = "grpcpro/src/pbfiles";

  message ProdModel {
    int32 id=1;   //商品ID
    string name=2;   //商品名称
  }

安装go插件：protoc-gen-go
  go get -u github.com/golang/protobuf/protoc-gen-go 

生成时可以指定
  --plugin=protoc-gen-go=E:\video\2021-2\grpcpath\gopath\bin\protoc-gen-go.exe

安装grpc库 （go版本）
  https://github.com/grpc/grpc-go
  go get -u google.golang.org/grpc@v1.37

写入第二个proto文件
  message ProdRequest {
    int32 prod_id =1;   //传入的商品ID
  }
  //请求返回的结果
  message ProdResponse {
    ProdModel result=1;   //结果
  }

  syntax = "proto3";
  option go_package = "grpcpro/src/pbfiles";
  import "models.proto";
  service ProdService {
    rpc GetProd(ProdRequest) returns (ProdResponse);
  }

装grpc插件 
  go get -u google.golang.org/grpc/cmd/protoc-gen-go-grpc

生成
  protoc --proto_path=protos --plugin=protoc-gen-go=E:\video\2021-2\grpcpath\gopath\bin\protoc-gen-go.exe   --go-grpc_out=./../   service.proto

客户端代码
  client,err:=grpc.DialContext(context.Background(),
		"localhost:8080",
		grpc.WithInsecure(),
  )

	if err != nil {
		log.Fatal(err)
	}

启动服务
  myserver:=grpc.NewServer()
	//创建服务
	pbfiles.RegisterProdServiceServer(myserver,&services.ProdService{})
	//监听8080
	lis,_:=net.Listen("tcp",":8080")
	if err:=myserver.Serve(lis);err!=nil {
		log.Fatal(err)
	}

证书(单向认证)
  制作证书
    这个部分 如果你使用的是类似istio这样的框架，可以自动开启。

    如果需要自己测试， 那么需要生成证书：
      根证书
      openssl genrsa -out ca.key 4096
      openssl req -new -x509 -days 3650 -key ca.key -out ca.crt

  SAN证书 
    SAN(Subject Alternative Name) 是 SSL 标准 x509 中定义的一个扩展。使用了 SAN 字段的 SSL 证书，可以扩展此证书支持的域名，使得一个证书可以支持多个不同域名的解析。

  yum 安装的openssl默认配置文件在：/etc/pki/tls/openssl.cnf

  执行 
  cp /etc/pki/tls/openssl.cnf .

  找到：[ req ]
  加入 req_extetions = v3_req

  找到：[ v3_req ]
  加入 subjectAltName = @alt_names

  找到：[ alt_names ]
  加入 
    DNS.1 = *.grpc.jtthink.com 
    DNS.2 = *.jtthink.com

  生成私钥：
    openssl genpkey -algorithm RSA -out server.key

  生成证书请求文件
    openssl req -new -nodes -key server.key -out server.csr -days 3650 \
      -subj "/C=cn/OU=jtthink/O=jtthink/CN=test.grpc.jtthink.com" \
      -config ./openssl.cnf -extensions v3_req
  
  查看
    openssl req -noout -text -in server.csr
  
  签发证书
    openssl x509 -req -days 3650 -in server.csr -out server.pem \
      -CA ./ca.crt -CAkey ./ca.key -CAcreateserial \
      -extfile ./openssl.cnf -extensions v3_req

    openssl x509 -noout -text -in server.pem

证书(双向认证)
  之前单向是在客户端也使用服务端的证书，现在不给客户端获取服务端的证书了
  生成私钥：
    openssl genpkey -algorithm RSA -out client.key

  生成证书请求文件
    openssl req \
      -new \
      -key client.key \
      -subj '/CN=myclient' \
      -out client.csr 
  
  签发证书
    openssl x509 \
      -req \
      -in client.csr \
      -CA ./ca.crt \
      -CAkey ./ca.key \
      -CAcreateserial \
      -days 3650 \
      -out client.crt
  
  客户端代码改造
    cert,_:=tls.LoadX509KeyPair("certs/client.crt","certs/client.key")
    certPool := x509.NewCertPool()
    ca, _ := ioutil.ReadFile("certs/ca.crt")
    certPool.AppendCertsFromPEM(ca)

    creds:=credentials.NewTLS(&tls.Config{
      Certificates: []tls.Certificate{cert},//客户端证书
      ServerName: "test.grpc.jtthink.com",
      RootCAs:      certPool,
    })

descriptor
  对一个proto文件的描述，
    1、文件名、包名、选项 
    2、文件中定义的所有message 所有service、 定义的extension、 依赖文件（import）等

    有了这些，我们可以利用反射 来做一些“不可描述的功能”
    譬如做个类似grpc-gateway的功能

  生成
    protoc  --proto_path=gsrc/protos  --include_imports --include_source_info --descriptor_set_out=prod.proto-descriptor  prod_service.proto

vue调用grpc的方法
  网页调用的方案
    1、使用grpc-gateway
    2、使用网关 如 istio的envoy filter 
    3、使用grpc-web

  grpc-web
    https://github.com/grpc/grpc-web/releases
    下载后，放到bin目录下

  生成
    protoc --proto_path=protos service.proto --js_out=import_style=commonjs:htmls --grpc-web_out=import_style=commonjs,mode=grpcwebtext:htmls

  npm install google-protobuf
  npm install  grpc-web 

  安装一个代理
    https://github.com/improbable-eng/grpc-web/releases
    文档：https://github.com/improbable-eng/grpc-web/tree/master/go/grpcwebproxy

  启动
    grpcwebproxy --backend_addr=localhost:8081 --server_http_debug_port=8082 --allow_all_origins --server_tls_cert_file=E:/video/2021-2/grpcpath/grpcpro/certs/server.pem  --server_tls_key_file=E:/video/2021-2/grpcpath/grpcpro/certs/server.key --backend_tls_noverify

  前端代码
    import { ProdServiceClient } from '@/grpc/service_grpc_web_pb'
    import { ProdRequest } from '@/grpc/models_pb'

    const client = new ProdServiceClient('http://localhost:8082');
    const req=new ProdRequest()
    req.setProdId("234")
    console.log(req)
    const metadata = {"Content-Type": "application/grpc-web-text"};
    client.getProd(req,metadata,(err,rsp)=>{
      if (err) {
        console.log(err.message);
      } else {
        console.log(rsp);
      }
    })

  grpc服务开启证书
    在我们之前基础上加入
      --backend_client_tls_cert_file=E:/video/2021-2/grpcpath/grpcpro/certs/client.crt --backend_client_tls_key_file=E:/video/2021-2/grpcpath/grpcpro/certs/client.key --backend_tls_ca_files=E:/video/2021-2/grpcpath/grpcpro/certs/ca.crt --backend_tls=true

    grpcwebproxy --backend_addr=test.grpc.jtthink.com:8081 --server_http_debug_port=8082 --allow_all_origins --server_tls_cert_file=E:/video/2021-2/grpcpath/grpcpro/certs/server.pem  --server_tls_key_file=E:/video/2021-2/grpcpath/grpcpro/certs/server.key --backend_client_tls_cert_file=E:/video/2021-2/grpcpath/grpcpro/certs/client.crt --backend_client_tls_key_file=E:/video/2021-2/grpcpath/grpcpro/certs/client.key --backend_tls_ca_files=E:/video/2021-2/grpcpath/grpcpro/certs/ca.crt --backend_tls=true

  流传输
    grpc-web支持服务端流

    测试代码
      for i:=0;i<5;i++{
        err:=rsp.Send(&pbfiles.ProdResponse{
          Result:&pbfiles.ProdModel{Id:int32(i+100),Name:"test"},
        })
        if err!=nil{
          return err
        }
      }

    前端代码
      const stream=client.getProd_Stream(req,metadata)
      stream.on('data', function(response) {
        console.log(response.getResult().getId());
      });
      stream.on('status', function(status) {
        console.log(status.code);
        console.log(status.details);
        console.log(status.metadata);
      });
      stream.on('end', function(end) {
        console.log("接收完毕")
      });

grpc身份验证
  gRPC 定义了PerRPCCredentials接口，用于自定义认证:
  将认证信息添加到每个RPC方法的上下文中。需要实现两个方法
    GetRequestMetadata：获取认证所需元数据
    RequireTransportSecurity：是否需要  TLS 

  服务端简单判断
    if md,ok:=metadata.FromIncomingContext(ctx);ok{
      fmt.Println(md["Token"])
    }else{
      return nil,status.Errorf(codes.Unauthenticated,"token faile")
    }

grpc权限认证
  go-grpc-middleware
    https://github.com/grpc-ecosystem/go-grpc-middleware
    认证（auth）, 日志（ logging）,   验证（validation）, 重试（retries） 和监控（monitoring）等拦截器

  grpc+casbin权限认证
    go get  github.com/casbin/casbin/v2

    权限设定
      两个角色:
        1、admin  (可以更新)
        2、member  (可以查看商品信息)

      r = sub, obj, act
      分表是 访问实体 (Subject)，访问资源 (Object) 和访问方法 (Action)
      譬如
      shenyi sub
      /usersv obj
      GET act

    初始化
      var E *casbin.Enforcer
      func init() {
        e,err:= casbin.NewEnforcer("casbin/model.conf","casbin/p.csv")
        if err!=nil{
          log.Fatal(err)
        }
        E=e
      }
