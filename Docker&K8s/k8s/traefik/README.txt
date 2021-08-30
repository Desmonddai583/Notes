Træfɪk 是一个为了让部署微服务更加便捷而诞生的现代HTTP反向代理、负载均衡工具。 
它支持多种后台(Docker, Swarm, Kubernetes, Marathon, Mesos, Consul, Etcd, Zookeeper, BoltDB, Rest API, file…) 来自动化、动态的应用它的配置文件设置
https://github.com/traefik/traefik
文档：https://doc.traefik.io/traefik/providers/kubernetes-crd/

部署
  1、helm repo add traefik https://helm.traefik.io/traefik
  2、helm repo update
  3、helm search repo traefik/traefik

  helm fetch traefik/traefik
  tar zxvf traefik-9.11.0.tgz

  image.tag 改成了 2.3.5
  websecure.port 改成了 9443  (因为 我8443给占用了)

  安装
    kubectl create ns tk
    kubectl label nodes dsjs2 traefik=true  在你认为需要安装traefik的节点上打标签
    helm install mytk traefik    -n tk
  
  更新是：
    helm upgrade mytk traefik    -n tk

  卸载则是
    helm uninstall mytk -n tk

  traefik的端口是9000
  web 是8000
  https是 9443 

使用IngressRoute创建服务反代
  https://doc.traefik.io/traefik/routing/providers/kubernetes-crd/
  traefik2支持 更方便的ingress配置 而创建的一个CRD

Path
  match: Host(`tk2.jtthink.com`) && Path(`/abc`) 当访问 /abc+host时 就会反代到我们的服务

中间件
  apiVersion: traefik.containo.us/v1alpha1
  kind: Middleware
  metadata:
    name: ngx-strip
  spec:
    stripPrefix:
      prefixes:
        - /abc

限流
  https://doc.traefik.io/traefik/middlewares/ratelimit/

  apiVersion: traefik.containo.us/v1alpha1
  kind: Middleware
  metadata:
    name: ngx-ratelimit
  spec:
    rateLimit:
      average: 1
      burst: 5
  
  参数的含义
    period = "3s"
    average = 1
    burst = 10
    平均每3秒接受1个请求，最大10 （桶的初始容量是10）

自定义响应头、跨域头
  apiVersion: traefik.containo.us/v1alpha1
  kind: Middleware
  metadata:
    name: cross-header
  spec:
    headers:
      customResponseHeaders:
        Myname: "shenyi"
        Myage: "19"

  https://doc.traefik.io/traefik/middlewares/headers/

  加入跨域头：
  Access-Control-Allow-Origin: "*"
  Access-Control-Allow-Methods: "POST, GET, OPTIONS, PUT, DELETE, UPDATE"
  Access-Control-Allow-Headers: "Origin, X-Requested-With, Content-Type, Accept, Authorization"
  Access-Control-Allow-Credentials: "true"
  Access-Control-Expose-Headers: "Content-Length, Access-Control-Allow-Origin, Access-Control-Allow-Headers, Cache-Control, Content-Language, Content-Type"

设置证书、https访问
  导入
    kubectl create secret tls mytls --cert=wx.jtthink.com_chain.crt --key=wx.jtthink.com_key.key  -n tk   
  配置
    - match: Host(`wx.jtthink.com`)
      kind: Rule
      services:
        - name: myngx
          port: 80
    tls:
      secretName: mytls

http跳https、中间件链
  apiVersion: traefik.containo.us/v1alpha1
  kind: Middleware
  metadata:
    name: redirect-https
  spec:
    redirectScheme:
      scheme: "https"
      port: "9443"
  
  中间件链
    apiVersion: traefik.containo.us/v1alpha1
    kind: Middleware
    metadata:
      name: ngx-secure
    spec:
      chain:
        middlewares:
          - name: redirect-https
          - name: cross-header

带权重的负载均衡、TraefikService使用
  https://doc.traefik.io/traefik/routing/providers/kubernetes-crd/#weighted-round-robin

  apiVersion: traefik.containo.us/v1alpha1
  kind: TraefikService
  metadata:
    name: wrr1
  spec:
    weighted:
      services:
        - name: ngx1-svc
          port: 80
          weight: 1
          kind: Service
        - name: ngx2-svc
          port: 80
          weight: 2
          kind: Service

TCP反代
  假设这个端口我们就是为 reids加的 （Redis默认6379）
  我们搞一个26379
  执行helm upgrade mytk traefik    -n tk
  安全组别忘了  开放端口 

  apiVersion: traefik.containo.us/v1alpha1
  kind: IngressRouteTCP
  metadata:
    name: redistcp
  spec:
    entryPoints:
      - redis
    routes:
      - match: HostSNI(`*`)
        services:
          - name: redis5
            port: 6379

  redis-cli -h tk1.jtthink.com -p 26379

创建grpc服务
  编译
    docker run --rm -it  \
      -v /home/shenyi/mygrpc:/app \
      -w /app \
      -v /home/shenyi/gopath:/go \
      -e CGO_ENABLED=0  \
      -e GOPROXY=https://goproxy.cn \
      golang:1.14.4-alpine3.12 \
      go build -o server  server.go

  配置
    apiVersion: traefik.containo.us/v1alpha1
    kind: IngressRoute
    metadata:
      name: grpc-route
      namespace: tk
    spec:
      entryPoints:
        - web
      routes:
        - match: Host(`tk1.jtthink.com`)
          kind: Rule
          services:
            - name: mygrpc-svc
              scheme: h2c
              port: 8080
  
  traefik反代grpc服务(带证书)
    客户端加入证书
      creds, err := credentials.NewClientTLSFromFile("mycert/wx.jtthink.com_chain.crt", "wx.jtthink.com")
      client,err:=grpc.Dial("wx.jtthink.com:9443",grpc.WithTransportCredentials(creds))

整合grpc-gateway
  客户端加入证书
    go install github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-grpc-gateway  github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-openapiv2 google.golang.org/protobuf/cmd/protoc-gen-go google.golang.org/grpc/cmd/protoc-gen-go-grpc
    文档 https://github.com/grpc-ecosystem/grpc-gateway

  加入Endpoint
    import "google/api/annotations.proto";

    rpc GetStock(ProdRequest) returns (ProdStockResponse){
        option (google.api.http) = {
        get: "/v1/prod/stock"
      };
    }
  
  加入生成配置
    protoc --proto_path=protos --grpc-gateway_out=logtostderr=true:pbfiles prod_service.proto

  http代码
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
  
  编译(grpc服务)
    docker run --rm -it  \
      -v /home/shenyi/mygrpc:/app \
      -w /app \
      -v /home/shenyi/gopath:/go \
      -e CGO_ENABLED=0  \
      -e GO111MODULE=on \
      -e GOPROXY=https://goproxy.io \
      golang:1.14.4-alpine3.12 \
      go build -o server   server.go 
 
  编译(grpc-gateway)
    docker run --rm -it  \
      -v /home/shenyi/mygrpc:/app \
      -w /app \
      -v /home/shenyi/gopath:/go \
      -e CGO_ENABLED=0  \
      -e GO111MODULE=on \
      -e GOPROXY=https://goproxy.io \
      golang:1.14.4-alpine3.12 \
      go build -o serverhttp  serverhttp.go 
  
  加入第二个容器
    - name: mygrpc-gateway
    image: alpine:3.12
    imagePullPolicy: IfNotPresent
    command: ["/app/serverhttp"]
    volumeMounts:
      - name: app
        mountPath: /app
    ports:
      - containerPort: 8081

身份验证中间件
  ForwardAuth中间件
    ForwardAuth中间件将身份验证委派给外部服务。如果服务响应代码为2XX，则将授予访问权限并执行原始请求。否则，将返回来自身份验证服务器的响应

  apiVersion: traefik.containo.us/v1alpha1
  kind: Middleware
  metadata:
    name: token-check
    namespace: tk
  spec:
    forwardAuth:
      address: http://authapi/auth
      trustForwardHeader: true
      tls:
        insecureSkipVerify: true
  
  准备一个程序
    判断这个头 X-Forwarded-Token   
    只要它有值就过，否则401
  
  集成jwt获取token
    go get github.com/dgrijalva/jwt-go

    请求测试
      http://localhost:8080/access_token?userid=shenyi&secret=123

  传递身份认证信息
    apiVersion: traefik.containo.us/v1alpha1
    kind: Middleware
    metadata:
      name: token-check
      namespace: tk
    spec:
      forwardAuth:
        address: http://authapi/auth
        authResponseHeaders:
          - X-Auth-User
        trustForwardHeader: true
        tls:
          insecureSkipVerify: true
  
  统一鉴权
    可以用自己的数据库来处理
    也可以集成casbin

traefike mesh 
  安装
    helm repo add traefik-mesh https://helm.traefik.io/mesh
    helm repo update

    kubectl create ns traefik-mesh
    helm fetch traefik-mesh/traefik-mesh   (做一些简单修改，要做修改。不然很难安装成功)
    helm install  traefik-mesh traefik-mesh   -n  traefik-mesh

  卸载
    helm uninstall traefik-mesh -n  traefik-mesh

  建立两个StorageClass和PV 
    metric-storage
  	prometheus-storage

  两个服务互相调用
    访问方式
      可以打开一个POD命令行工具
      执行curl  服务名.命名空间.traefik.mesh

    限流
      加入限流标记:
        annotations:
              mesh.traefik.io/ratelimit-average: "1"
              mesh.traefik.io/ratelimit-burst: "1"

    执行这个测试
      curl -I  -o /dev/null -s -w %{http_code}  ngx2-svc.tk.traefik.mesh

  熔断器
    apiVersion: traefik.containo.us/v1alpha1
    kind: Middleware
    metadata:
      name: latency-check
    spec:
      circuitBreaker:
        expression: LatencyAtQuantileMS(50.0) > 1000

    LatencyAtQuantileMS
      代表延迟：Latency
      quantile ：代表分位数 
      50 .0就是m0.5 (就是中位数) ,官方规定必须写成浮点类型
      中位数计算方法 https://baike.baidu.com/item/%E4%B8%AD%E4%BD%8D%E6%95%B0/3087401?fr=aladdin

    ResponseCode熔断
      NetworkErrorRatio() > 0.5：网络异常大于50%时，熔断

      ResponseCodeRatio(500, 600, 0, 600) > 0.5：
        监测返回状态码为[500-600]的数量  10
          在[0-600] 这个区间占比超过50%时，熔断  20
  
  聚合接口+mesh架构
    https://github.com/nats-io/nats-operator

    部署集群
      apiVersion: nats.io/v1alpha2
      kind: NatsCluster
      metadata:
        name: mynats
      spec:
        size: 1
        version: "2.1.8"

    nats默认的连接端口是4222
    为了让我们本机能够连接，我们使用 14222

    客户端
      go get github.com/nats-io/nats.go

    一个API (http api )
    GET  /prods/hot

    1、有个grpc API 
      这个API 获取出推荐商品
    2、有一个 http api  ,负责处理商品相关的路由
      /prods/xxxx
    3、当用户请求http api时，我们发送消息到nats里，然后等待响应

    基本模型
      message ProdModel {
          int32 id=1;
          string name=2;
      }
      message  HotProdRequest {
          int32 size =1;   //取多少条
      }
      message  HotProdResponse {
          repeated ProdModel result=1;   //结果
      }

    基本Service
      rpc GetHotProds(HotProdRequest) returns (HotProdResponse);

    消费者代码、请求grpc
      lib.InitBroker()
      _,err:= lib.Broker.Subscribe("prods.get.hot", func(msg *nats.Msg) {
      prodsClient:=lib.InitProdsClient()

      初始化代码
        func InitProdsClient() *grpc.ClientConn{
          client,err:=grpc.DialContext(context.Background(),
            "prodservice.tk.traefik.mesh:80",grpc.WithInsecure())
          if err!=nil{
            log.Fatal(err)
          }
          return client
        }

      rsp:=new(pbfiles.HotProdResponse)
      req:=new(pbfiles.HotProdRequest)
      err:=proto.Unmarshal(msg.Data,req)
      err=prodsClient.Invoke(context.Background(),
              "/ProdService/GetHotProds",req,rsp)
      rspBytes,err:=proto.Marshal(rsp)
      err=lib.Broker.Publish(msg.Reply,rspBytes )

    设置网格熔断和降级
      在我们的实际grpc 服务代码中加入
      time.Sleep(time.Second*3)
      这样在消费者得到数据的过程 就会很慢

      可以加个熔断策略
      mesh.traefik.io/circuit-breaker-expression: "LatencyAtQuantileMS(50.0) > 1000"

  traefike mesh 自带了jaeger的链路追踪服务,可以开启查看