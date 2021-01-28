Protobuf  
  Google Protocol Buffer( 简称 Protobuf)

  轻便高效的序列化数据结构的协议，可以用于网络通信和数据存储。
  特点：性能高、传输快、维护方便，反正就是各种好，各种棒
  一些第三方rpc库都会支持protobuf  

  github地址 https://github.com/protocolbuffers/protobuf

  golang库所属地址 https://github.com/golang/protobuf

服务端设置
  引用grpc模块
    go get -u google.golang.org/grpc

  安装插件  
    会在GOPATH的bin目录下生成可执行文件. protobuf的编译器插件protoc-gen-go，执行protoc命令时就会自动调用这个插件
    go get github.com/golang/protobuf/protoc-gen-go

  创建proto文件
    syntax="proto3";
    package services;
    message  ProdRequest {
        int32 prod_id =1;   //传入的商品ID
    }
    message ProdResponse{
        int32 prod_stock=1;//商品库存
    }
    service ProdService {
      rpc GetProdStock (ProdRequest) returns (ProdResponse);
    }

  执行protoc --go_out=plugins=grpc:../services Prod.proto

  创建实现方法
    type ProdService struct {
    }
    func(this *ProdService) GetProdStock(ctx context.Context, in *ProdRequest) (*ProdResponse, error) {
      return &ProdResponse{ProdStock:22},nil
    }
  
  创建服务
    prodServer:=grpc.NewServer()
    services.RegisterProdServiceServer(prodServer,new(services.ProdService))

    lis,_:=net.Listen("tcp",":8082")
    prodServer.Serve(lis)

客户端设置
  go get google.golang.org/grpc

  客户端代码
    client,err:=grpc.Dial(":8081",grpc.WithInsecure())
    if err!=nil{
      log.Fatal(err)
    }
    defer client.Close()
    prodClient:=services.NewProdServiceClient(client)
    res,err:=prodClient.GetProdStock(
      context.Background(),
      &services.ProdRequest{ProdId:12},
    )
    if err!=nil{
      log.Fatal(err)
    }
    fmt.Println(res.ProdStock)

服务加入证书验证
  1、执行openssl
  2、执行 genrsa -des3 -out server.key 2048（会生成server.key,私钥文件）
  3、创建证书请求：req -new -key server.key -out server.csr（会生成server.csr） 其中common name 也就是域名
  4、删除密码 rsa -in server.key -out server_no_passwd.key
  5、执行x509 -req -days 365 -in server.csr -signkey server_no_passwd.key -out server.crt (会生成server.crt)
  自此自签证书完成

  加入证书代码:服务端
    creds, err := credentials.NewServerTLSFromFile("keys/server.crt", "keys/server_no_passwd.key")
    if err != nil {
      log.Fatal(err)
    }
    rpcServer:=grpc.NewServer(grpc.Creds(creds))

  加入证书代码:客户端
    creds, err := credentials.NewClientTLSFromFile("keys/server.crt", "jtthink.com")
    if err != nil {
      log.Fatal(err)
    }
    conn,err:=grpc.Dial(":8081",grpc.WithTransportCredentials(creds))

  双向认证
    使用CA证书
      根证书（root certificate）是属于根证书颁发机构（CA）的公钥证书。 用以验证它所签发的证书（客户端、服务端）
      1、openssl
      2、 genrsa -out ca.key 2048
      3、req -new -x509 -days 3650 -key ca.key -out ca.pem
    
    生成服务端证书
      1、genrsa -out server.key 2048
      2、req -new -key server.key -out server.csr 注意common name 请填写localhost
      3、x509 -req -sha256 -CA ca.pem -CAkey ca.key -CAcreateserial -days 3650 -in server.csr -out server.pem

    生成客户端证书
      1、 ecparam -genkey -name secp384r1 -out client.key
      2、 req -new -key client.key -out client.csr
      3、x509 -req -sha256 -CA ca.pem -CAkey ca.key -CAcreateserial -days 3650 -in client.csr -out client.pem

    服务端代码改造
      cert,_:=tls.LoadX509KeyPair("cert/server.pem","cert/server.key")
      certPool := x509.NewCertPool()
      ca, _ := ioutil.ReadFile("cert/ca.pem")
      certPool.AppendCertsFromPEM(ca)

      creds:=credentials.NewTLS(&tls.Config{
        Certificates: []tls.Certificate{cert},
        ClientAuth:   tls.RequireAndVerifyClientCert,
        ClientCAs:    certPool,
      })

    客户端代码改造
      cert,_:=tls.LoadX509KeyPair("cert/client.pem","cert/client.key")
      certPool := x509.NewCertPool()
      ca, _ := ioutil.ReadFile("cert/ca.pem")
      certPool.AppendCertsFromPEM(ca)

      creds:=credentials.NewTLS(&tls.Config{
        Certificates: []tls.Certificate{cert},
        ServerName: "localhost",
        RootCAs:      certPool,
      })

双向认证下rpc-gateway使用（同时提供rpc和http接口）
  安装
    go get -u github.com/grpc-ecosystem/grpc-gateway/protoc-gen-grpc-gateway
    go get -u github.com/grpc-ecosystem/grpc-gateway/protoc-gen-swagger
    go get -u github.com/golang/protobuf/protoc-gen-go

  修改proto文件
    import "google/api/annotations.proto"; 
    service ProdService {
      rpc GetProdStock (ProdRequest) returns (ProdResponse){
        option (google.api.http) = {
          get: "/v1/prod/{prod_id}"
        };
      }
    }

  生成两个文件
    protoc --go_out=plugins=grpc:../services  Prod.proto                 生成Prod.pb.go 
    protoc --grpc-gateway_out=logtostderr=true:../services Prod.proto    生成Prod.pb.gw.go

  关键代码
    gwmux:=runtime.NewServeMux()
    opt:=[]grpc.DialOption{grpc.WithTransportCredentials(helper.GetClientCreds())}
    err:=services.RegisterProdServiceHandlerFromEndpoint(context.Background(),gwmux,"localhost:8081",opt)
    if err != nil {
      log.Fatal(err)
    }
    err=server.ListenAndServe()
    if err != nil {
      log.Fatal(err)
    }

Protobuf语法
  repeated修饰符
    message QuerySize{
      int32 size=10;   
    }
    message ProdStockList{
      repeated ProdResponse prodres=1;
    }
    Repeated:是一个修饰符,返回字段可以重复任意多次（包括0次），可以认为就是一个数组(切片)

    方法 rpc GetProdStocks(QuerySize) returns (ProdStockList){}

    主体方法
      func(this *ProdService) GetProdStocks(ctx context.Context, in *QuerySize) (*ProdStockList, error){
        prodres:=[]*ProdResponse{
          &ProdResponse{ProdStock:28},
          &ProdResponse{ProdStock:29},
          &ProdResponse{ProdStock:30},
          &ProdResponse{ProdStock:31},
        }
        return &ProdStockList{
          Prodres:prodres,
        },nil
      }

  枚举
    enum ProdAreas{
      A=0;
      B=1;
      C=2;
    }

    message  ProdRequest {
      int32 prod_id =1;   //传入的商品ID
      ProdAreas prod_area=2;
    }

  导入外部Proto
    import "Models.proto";

  日期类型
    import "google/protobuf/timestamp.proto";
    message OrderMain{ //主订单模型
      int32 order_id=1;//订单ID，数字自增
      string order_no=2; //订单号
      int32 user_id=3; //购买者ID
      float order_money=4;//商品金额
      google.protobuf.Timestamp order_time=5;
    }

    message OrdersResponse{
      string status=1;
      string message=2;
    }
    service OrdersService{
      rpc NewOrders(OrderMain) returns (OrdersResponse){}
    }

    客户端调用
      now:=time.Now()
      t:=timestamp.Timestamp{Seconds:now.Unix(),Nanos:0}
      res,err:=ordersClinet.NewOrders(ctx,&services.OrderMain{
        OrderId:101,
        OrderNo:"20190912",
        OrderMoney:90,
        OrderTime:&t,
      })
      fmt.Println(res)

gateway实现http api
  增加网关POST规则
    service OrderSerivce{
      rpc NewOrder(OrderRequest) returns (OrderResponse){
        option (google.api.http) = {
          post: "/v1/orders"
          body:"order_main"
        };
      }
    }
  增加编译选项(网关)
    protoc  --grpc-gateway_out=logtostderr=true:../services Prod.proto
    protoc  --grpc-gateway_out=logtostderr=true:../services Orders.proto

使用第三方库进行字段验证
  go get -u github.com/envoyproxy/protoc-gen-validate

  import "validate.proto";
  ……
  float order_money=4 [(validate.rules).float.gt    = 1];

  增加编译选项(网关)
    protoc --go_out=plugins=grpc:../services --validate_out=lang=go:../services Models.proto

流模式
  如果是传输较大数据会带来
    1、数据包过大导致压力陡增
    2、需要等待客户端包全部发送，才能处理以及响应

  批量查询用户积分为例

  不使用流模式
    先创建用户模型
      message UserInfo{
        int32 user_id=1;
        int32 user_score=2;
      }

    创建Users.proto
      syntax="proto3";
      package services;
      import "Models.proto";
      message UserScoreRequest{
          repeated UserInfo users=1;
      }
      message UserScoreResponse{
          repeated UserInfo users=1;
      }
      service UserService{
          rpc GetUserScore(UserScoreRequest) returns (UserScoreResponse);
      }

    生成部分
      protoc --go_out=plugins=grpc:../services   Users.proto
      protoc  --grpc-gateway_out=logtostderr=true:../services Users.proto

    编写UserService
      type UserService struct {
      }
      func(*UserService) GetUserScore(ctx context.Context, in *UserScoreRequest)  (*UserScoreResponse, error){
        var score int32=101
        users:=make([]*UserInfo,0)
          for _,user:=range in.Users{
            user.UserScore=score
        score++
        users=append(users,user)
        }
        return &UserScoreResponse{Users:users},nil
      }

    客户端调用
      userClient:=services.NewUserServiceClient(conn)
      var i int32
      req:=services.UserScoreRequest{}
      req.Users=make([]*services.UserInfo,0)

      for i=1;i<20;i++{
        req.Users=append(req.Users,&services.UserInfo{UserId:i})
      }
      res,err:=userClient.GetUserScore(ctx,&req)
      fmt.Println(res.Users)

  服务端流模式(分批发送查询结果)
    采用的策略是服务端每查询2个就发送给客户端

    修改users.proto
      rpc GetUserScoreByServerStream(UserScoreRequest) returns (stream UserScoreResponse);

    处理方法
      func(*UserService) GetUserScoreByServerStream(in *UserScoreRequest,stream UserService_GetUserScoreByServerStreamServer) error{
        var score int32=101
        users:=make([]*UserInfo,0)
        for index,user:=range in.Users{
          user.UserScore=score
          score++
          users=append(users,user)

          if (index+1) %2==0 && index>0{
            err:=stream.Send(&UserScoreResponse{Users:users})
            if err!=nil{
              return nil
            }
            users=(users)[0:0]
          }
        }
        return nil
      }
    
    客户端调用
      stream,_:=userClient.GetUserScoreByServerStream(ctx,&req)
      for {
        resp, err := stream.Recv()
        if err == io.EOF {
          break
        }
        if err != nil {
          log.Fatal(err)
        }

        fmt.Println(resp.Users)
      }

  客户端流模式(分批发送请求)
    1、客户端一次性把用户列表发送过去（客户端获取列表比较慢）
    2、服务端查询积分比较快 
    此时可以使用客户端流模式

    修改users.proto
      rpc GetUserScoreByClientStream(stream UserScoreRequest) returns (UserScoreResponse);
    
    处理方法
      func(*UserService) 	GetUserScoreByClientStream(stream UserService_GetUserScoreByClientStreamServer) error{
        var score int32=101
        users:=make([]*UserInfo,0)
        for{
          req,err:=stream.Recv()
          if err==io.EOF{
            return stream.SendAndClose(&UserScoreResponse{Users:users})
          }
          if err!=nil{
            return err
          }
          for _,user:=range req.Users{
            user.UserScore=score
            score++
            users=append(users,user)
          }
        }
      }

    客户端调用
      stream,_:=userClient.GetUserScoreByServerStream(ctx,&req)
      for {
        resp, err := stream.Recv()
        if err == io.EOF {
          break
        }
        if err != nil {
          log.Fatal(err)
        }

        fmt.Println(resp.Users)
      }

  双向流模式
    修改users.proto
      rpc GetUserScoreByTWS(stream UserScoreRequest) returns (stream UserScoreResponse);
    
    服务端
      //双向流
      func(*UserService) GetUserScoreByTWF(stream UserService_GetUserScoreByTWFServer) error  {
        var score int32=101
        users:=make([]*UserInfo,0)
        for{
          req,err:=stream.Recv()
          if err==io.EOF{ //接收完了
            return nil
          }
          if err!=nil{
            return err
          }
          for _,user:=range req.Users{
            user.UserScore=score  //这里好比是服务端做的业务处理
            score++
            users=append(users,user)
          }
          err=stream.Send(&UserScoreResponse{Users:users})
          if err!=nil{
            log.Println(err)
          }
          users=(users)[0:0]
        }
      }

    客户端
      res,err:=stream.Recv()
      if err==io.EOF{
        break;
      }
      if err!=nil{
        log.Println(err)
      }
      fmt.Println(res.Users)