grpc构建
  Models.proto
    syntax = "proto3";
    package  Services;

    message ProdModel{
        // @inject_tag: json:"pid"
        int32 ProdID =1;
        // @inject_tag: json:"pname"
        string ProdName=2;
    }

  ProdService.proto
    syntax = "proto3";
    package  Services;
    import "Models.proto";
    message ProdsRequest{
        int32 size=1;
    }
    message ProdListResponse{
        repeated ProdModel data=1;
    }
    service ProdService{
        rpc getProdsList(ProdsRequest) returns(ProdListResponse);
    }

  生成部分（批处理）
    cd Services/protos
    protoc  --micro_out=../ --go_out=../ Models.proto
    protoc  --micro_out=../ --go_out=../ ProdService.proto
    protoc-go-inject-tag -input=../Models.pb.go
    cd .. && cd ..

  实现类
    func newProd(id int32,pname string) *Services.ProdModel{
      return &Services.ProdModel{ProdID:id,ProdName:pname}
    }
    type ProdService struct {

    }
    func(*ProdService) GetProdsList(ctx context.Context, in *Services.ProdsRequest, res *Services.ProdListResponse) error{
      models:=make([]*Services.ProdModel,0)
      var i int32
      for i=0;i<in.Size;i++{
        models=append(models,newProd(100+i,"prodname"+strconv.Itoa(100+int(i))))
      }
      res.Data=models
      return nil
    }

  启动类
    consulReg:=consul.NewRegistry(
      registry.Addrs("192.168.29.135:8500"),
    )
    service := micro.NewService(
      micro.Name("prodservice"),
      micro.Registry(consulReg),
    )
    service.Init()
    Services.RegisterProdServiceHandler(service.Server(),new(ServiceImpl.ProdService))
    service.Run()
  
gin中调用
  把rpc服务中的proto文件拷贝过去
  
  生成部分（批处理）
    cd Services/protos
    protoc  --go_out=../ Models.protoprotoc  --micro_out=../ --go_out=../ ProdService.proto
    protoc-go-inject-tag -input=../Models.pb.go
    cd .. && cd ..

  基本代码
    serivce:=micro.NewService(
		  micro.Name("prodservice.client"),
    )
    prodService:=Services.NewProdService("prodservice",serivce.Client())

    var pr  Services.ProdsRequest
    err:=ginctx.Bind(&pr)
    if err!=nil{
        ginctx.JSON(500,gin.H{
        "status":err.Error(),
      })
        ginctx.Abort()
    }else{
      res,err:=prodService.GetProdsList(context.Background(),&pr)
      if err!=nil {
        ginctx.JSON(500, gin.H{
          "status": err.Error(),
        })
      }else{
        ginctx.JSON(200,gin.H{"data":res.Data})
      }
    }
  
  补上form参数
    message ProdsRequest{
        // @inject_tag: json:"size",form:"size"
        int32 size=1;
    }

    生成部分加入
      protoc-go-inject-tag -input=../ProdService.pb.go

Go-micro的装饰器wrapper(中间件)
  文档 https://github.com/micro/go-plugins/tree/master/wrapper

熔断器使用
  hystrix它提供服务的熔断、降级、隔离等
  Go也有对应的库https://github.com/afex/hystrix-go
  不用安装，go-micro的plugins已经帮我们集成了

  初步的调用
    err:=hystrix.Do(“命令名称", func() error {
      return nil
    },nil)
    if err!=nil{
      fmt.Println(err)
    }

  创建一个 hystrix config
    configA:=hystrix.CommandConfig{
      Timeout:1000,
    }

  command配置命令
    hystrix.ConfigureCommand("getprods",configA)

  command执行
    var prodRes *Services.ProdListResponse
    err:=hystrix.Do("getprods", func() error {
      prodRes,err= prodService.GetProdsList(context.Background(),&prodReq)
      return err
    },nil)
    if err!=nil{
      ginCtx.JSON(500,gin.H{"status":err.Error()})
    }else{
      ginCtx.JSON(200,gin.H{"data":prodRes.Data})
    }

  服务降级
    hystrix.Do的第三个参数可传入一个callback函数用来做降级服务调用
    func newProd(id int32,pname string) *Services.ProdModel{
      return &Services.ProdModel{ProdID:id,ProdName:pname}
    }
    func defaultProds() (*Services.ProdListResponse,error) {
      models:=make([]*Services.ProdModel,0)
      var i int32
      for i=0;i<5;i++{
        models=append(models,newProd(20+i,"prodname"+strconv.Itoa(20+int(i))))
      }
      res:=&Services.ProdListResponse{}
      res.Data=models
      return res,nil
    }
  
  整合hystrix到go-micro中
    使用wrapper
      type ProdsWrapper struct {
        client.Client
      }
      func (this *ProdsWrapper) Call(ctx context.Context, req client.Request, rsp interface{}, opts ...client.CallOption) error {
        fmt.Println(req.Service()+"."+req.Endpoint())
        hystrix.ConfigureCommand(req.Service()+"."+req.Endpoint(),configA)
        return hystrix.Do(req.Service()+"."+req.Endpoint(), func() error {
          return this.Client.Call(ctx, req, rsp, opts...)
        }, nil}
      }
      func NewProdsWrapper(c client.Client) client.Client {
        return &ProdsWrapper{Client:c}
      }

  增加商品详细API(grpc)
    设定的API地址是 GET /prods/123 这种形式
      message ProdsRequest{
      // @inject_tag: json:"size",form:"size"
          int32 size=1;
          // @inject_tag: uri:"pid"
          int32 prod_id=2;
      }
      message ProdDetailResponse{
          ProdModel data=1;
      }

    实现方法
      func(*ProdService) GetProdsDetail(ctx context.Context, req *Services.ProdsRequest, rsp *Services.ProdDetailResponse) error  {
        rsp.Data=newProd(req.ProdId,"商品详细")
        return nil
      }

    异常处理中间件
      func ErrorMiddleware() gin.HandlerFunc  {
        return func(context *gin.Context) {
          defer func() {
            if r:=recover();r!=nil{
              context.JSON(500,gin.H{"status":fmt.Sprintf("%s",r)})
              context.Abort()
            }
          }()
          context.Next()
        }
      }

    Gin的Handler方法
      func PanicIfErr(err error)  {
        if err!=nil{
          panic(err)
        }
      }
      func GetProdDetail(ginCtx *gin.Context){
        var prodReq Services.ProdsRequest
        PanicIfErr(ginCtx.BindUri(&prodReq))
        prodService:=ginCtx.Keys["prodservice"].(Services.ProdService)
        prodRes,_:=prodService.GetProdsDetail(context.Background(),&prodReq)
        ginCtx.JSON(200,gin.H{"data":prodRes.Data})
      }

  通用降级方法
    func defaultData(rsp interface{})  {
      switch t:=rsp.(type) {
      case *Services.ProdListResponse:
          defaultProds(rsp)
      case *Services.ProdDetailResponse:
          t.Data=newProd(10,"降级商品")
      default:
        panic("not support type")
      }
    }

  熔断器的参数设置
    主要是三个参数:
    RequestVolumeThreshold: 默认20,熔断器请求阀值，意思是有20个请求才进行 错误百分比计算
    ErrorPercentThreshold: 就是错误百分比。默认50（50%）
    SleepWindow:5000 过多长时间，熔断器再次检测是否开启。单位毫秒 (默认5秒)

微服务工具箱（运行时）
  Micro工具集(toolkit)，可以认为是一个微服务工具包，可以帮助我们来完成
  API Gateway(网关)，cli(客户端命令)， Sidecar(异构语言的接入)、模板生成和Web 管理界面 

  consulReg:=consul.NewRegistry(
		registry.Addrs("192.168.29.135:8500"),
	)
	service:=micro.NewService(
		micro.Name("test.jtthink.com"),
		micro.Registry(consulReg),
		micro.Address(":8001"),
		)
	Services.RegisterTestServiceHandler(service.Server(),new(SerivcesImpl.TestService))
	service.Init()
	if err := service.Run(); err != nil {
		log.Fatal(err)
	}

  获取出当前有多少服务注册到了consul中
    micro --registry consul --registry_address 192.168.29.135:8500 list services

  Micro工具查看和调用服务
    获取服务的元信息
      micro --registry consul --registry_address 192.168.29.135:8500 get service test.jtthink.com
    调试服务
      micro --registry consul --registry_address 192.168.29.135:8500 call test.jtthink.com TestService.Call "{\"id\": 3}"

  使用Micro为rpc服务创建http api网关
    基本命令 micro api   

    批处理
      set MICRO_REGISTRY=consul
      set MICRO_REGISTRY_ADDRESS=192.168.29.135:8500
      set MICRO_API_NAMESPACE=api.jtthink.com
      set MICRO_API_HANDLER=rpc
      micro api

    POST 的方式去请求
      http://localhost:8080/test/TestService/call

  创建grpc网关
    使用grpc https://github.com/grpc-ecosystem/grpc-gateway

    基本步骤
      go get -u google.golang.org/grpc
      go get -u github.com/grpc-ecosystem/grpc-gateway/protoc-gen-grpc-gateway
      go get -u github.com/grpc-ecosystem/grpc-gateway/protoc-gen-swagger
      go get -u github.com/golang/protobuf/protoc-gen-go
    
    修改proto文件
      import “google/api/annotations.proto”; (这个要加下)

      service TestService{
          rpc Call(TestRequest) returns(TestResponse){
              option (google.api.http) = {
                  get: "/test/{id}"
              };
          }
      }
    
    生成部分
      protoc --go_out=plugins=grpc:../../ServiceGW test.proto
      protoc --grpc-gateway_out=logtostderr=true:../../ServiceGW test.proto

    网关代码
      ctx := context.Background()
      ctx, cancel := context.WithCancel(ctx)
      defer cancel()
      gRpcEndPoint:="localhost:8001"
      mux := runtime.NewServeMux()
      opts := []grpc.DialOption{grpc.WithInsecure()}
      err := ServiceGW.RegisterTestServiceHandlerFromEndpoint(ctx, mux, gRpcEndPoint, opts)
      if err != nil {
        log.Fatal(err)
      }
      http.ListenAndServe(":9000", mux)

用户注册场景
  设计接口
    1、user_id   int 
    2、user_name varchar(50)
    3、user_pwd varchar(50)
    4、user_date datetime

  Proto文件
    创建一个Models
      syntax="proto3";
      package Services;
      import "google/api/annotations.proto";
      import  "google/protobuf/timestamp.proto";
      message UserModel{
          int32 user_id=1;
          string user_name=2;
          string user_email=3;
          google.protobuf.Timestamp user_addtime=5;
      }
    
    UserService.proto
      syntax="proto3";
      package Services;
      import "Models.proto";

      message RegResponse{
          string status=1;
          string message=2;
      }
      service UserSerice{
          rpc UserReg(UserModel) returns(RegResponse);
      }

  生成代码
    protoc   --go_out=../ Models.proto
    protoc --micro_out=../ --go_out=../ UserService.proto
    protoc-go-inject-tag -input=../Models.pb.go
    protoc-go-inject-tag -input=../UserService.pb.go

  引入ORM
    go get -u github.com/jinzhu/gorm

  创建模型
    type Users struct {
        UserId      int  `gorm:"column:user_id;AUTO_INCREMENT;PRIMARY_KEY"`
        UserName    string  `gorm:"column:user_name;type:varchar(50);unique_index"`
        UserPwd   string  `gorm:"column:user_pwd;type:varchar(50)"`
        UserDate time.Time `gorm:"column:user_date"`
    }

  数据库初始化
    var db *gorm.DB
    func init() {
      var err error
      db, err = gorm.Open("mysql",
        "root:123123@tcp(localhost:3307)/gmicro?charset=utf8mb4&parseTime=True&loc=Local")
      if err != nil {
        log.Fatal(err)
      }
      db.DB().SetMaxIdleConns(10)
      db.DB().SetMaxOpenConns(50)
    }
    func  GetDB() *gorm.DB {
      return db
    }

  数据验证
    go get gopkg.in/go-playground/validator.v9

    基本用法
      type Users struct {
        UserName string `validate:"required,min=6,max=20"`
        UserPwd string `validate:"required,min=6,max=18"`
      }

      user:=Users{UserName:"shenyi",UserPwd:"123"}
      valid:=validator.New()
      err:= valid.Struct(user)
      if err!=nil{
        log.Fatal(err)
      }
      fmt.Println("验证通过")
    
    获取具体的error信息
      if err!=nil{
        errs := err.(validator.ValidationErrors)
        for _, e := range errs {
          fmt.Println(e.Value())
          fmt.Println(e.Field())
          fmt.Println(e.Tag())
        }
        log.Fatal(err)
      }

    写个初步的自定义函数
      func GetValidErrorMsg(u interface{},field string)  {
        t := reflect.TypeOf(u)
        if f,exist:=t.Elem().FieldByName(field);exist{
          fmt.Println(f.Tag.Get("vmsg"))
        }
      }
  
    自定义验证tag、正则验证
      用户名的规则是
        1、首字母必须是字母
        2、其余只能是数字、字母或下划线
        3、长度在6,20位之间
        [a-zA-Z]\\w{5,19}

      基本代码
        _=valid.RegisterValidation("username", func(fl validator.FieldLevel) bool {
          match,err:=regexp.MatchString("[a-zA-Z]\\w{5,20}",fl.Field().String())
          if err!=nil || !match {
            return false
          }
          return true
        },true)

      封装
        func AddRegexTag(tagName string,pattern string,v *validator.Validate) error {
          return v.RegisterValidation(tagName, func(fl validator.FieldLevel) bool {
              match,_:=regexp.MatchString(pattern,fl.Field().String())
              return match
          },true)
        }

    切片属性的验证(string切片)
      type Users struct {
        Username string `validate:"required,min=6,max=20" vmsg:"用户名规则不正确" `
        Userpwd string `validate:"required,min=6,max=18" vmsg:"用户密码必须6位以上"`
        Usertags []string
      }

      usertags 代表是用户标签
      1、用户注册时必须填一个
      2、里面每一个tag的内容不能相同
      3、最多不能超过5个

      Usertags []string `validate:"required,min=1,max=5,unique,dive,usertag" vmsg:"用户标签不合法"`

      测试
        userTags:=[]string{"a","b","c","d","a"}
        user:=&Users{Username:"shenyi",Userpwd:"123123",Usertags:userTags}

      假设标签只能是字母数字或中文,就要写到正则了
        ^[\u4e00-\u9fa5a-zA-Z0-9]{2,4}$

go-micro升级到1.14
  确保go已经使用go 1.13 

  先装
    go get github.com/micro/go-micro

  然后装plugins
    go get github.com/micro/go-plugins

  安装时出现错误的解决方法
    https://github.com/golang/go/issues/34394
    解决方法：在go.mod里加入
      replace github.com/gogo/protobuf v0.0.0-20190410021324-65acae22fc9 => github.com/gogo/protobuf v0.0.0-20190723190241-65acae22fc9d
    然后再执行安装:go get github.com/micro/go-plugins

  如果出现undefined: qtls.CipherSuite
  首先安装（注意后面的@master）
    go get github.com/lucas-clemente/quic-go@master

  然后在go.mod里面找到版本号譬如是 
    github.com/lucas-clemente/quic-go v0.7.1-0.20191025234737-672328ca3059

  然后 在go.mod里加入
    replace github.com/lucas-clemente/quic-go => github.com/lucas-clemente/quic-go v0.7.1-0.20191025234737-672328ca3059

  此时可以再次执行go get github.com/micro/go-micro (注意不要加-u)

  如果发现go-plugins没有有consul相关内容
    go get github.com/micro/go-plugins@master

迁移etcd
  https://micro.mu/blog/2019/10/04/deprecating-consul.html
  1、k8s作为容器编排的主力，使用了 etcd
  2、在一些案例中发现了关于consul使用上的问题
  因此未来即将弃用consul。 如果使用新版本，那么应该使用etcd

  启动etcd的容器
  把之前的服务 使用etcd作为注册中心
  启动一个web界面

普通API集成到go-micro
  go get github.com/gin-gonic/gin

  随便写个API
    ginRouter:=gin.Default()
    v1:=ginRouter.Group("/v1")
    {
      v1.Handle("POST","/test", func(context *gin.Context) {
        context.JSON(200,gin.H{
          "data":"test",
        })
      })
    }
    server:=&http.Server{
      Addr:":8088",
      Handler:ginRouter,
    }
    go(func() {
      server.ListenAndServe()
    })()
    notify := make(chan os.Signal)
    signal.Notify(notify, syscall.SIGTERM, syscall.SIGINT, syscall.SIGKILL)
    <-notify

    server.Shutdown(context.Background())

  启动如下命令
    set MICRO_REGISTRY=etcd
    set MICRO_REGISTRY_ADDRESS=192.168.29.135:23791
    micro registry
  
  测试
    POST 请求  http://localhost:8000/
    参数如下：
      {"jsonrpc":"2.0","method":"Registry.Register","params":[{"name":"api.jtthink.com.test","version":"1.0","endpoints":[],"nodes":[{"address":"192.168.29.1","id":"userservice-uuid","port":8088}]}],"id":1}

  代码注册与反注册
    struct :Service和Node
      type Service struct {
        Name string
        Nodes []*ServiceNode
      }
      type ServiceNode struct {
        Id string
        Port int
        Address string
      }
      func NewService(name string) *Service {
        return &Service{Name:name,Nodes:make([]*ServiceNode,0)}
      }
      func NewServiceNode(id string,port int,address string ) *ServiceNode  {
        return &ServiceNode{Id:id,Port:port,Address:address}
      }
      func(this *Service) AddNode(id string,port int,address string ){
        this.Nodes=append(this.Nodes,NewServiceNode(id,port,address))
      }

    Register
      type JSONRequest struct {
        Jsonrpc string
        Method string
        Params []*Service
        Id int
      }
      func NewJSONRequest(service *Service,endpoint string ) *JSONRequest {
        return &JSONRequest{Jsonrpc:"2.0",Method:endpoint,Params:[]*Service{service},Id:1}
      }

      func requestRegistry(jsonrequest *JSONRequest) error  {  //关键代码。用来请求注册器
        b, err := json.Marshal(jsonrequest)
        if err!=nil{
          log.Fatal(err)
          return err
        }
        rsp,err:=http.Post(RegistryURI, "application/json", bytes.NewReader(b))
        if err!=nil{
          return err
        }
        defer rsp.Body.Close()
        res,err:=ioutil.ReadAll(rsp.Body)
        if err!=nil{
          return err
        }
        fmt.Println(string(res))  //打印出结果
        return nil
      }

      var RegistryURI=“http://localhost:8000” //默认值
      func UnRegService(service *Service) error  {
        return requestRegistry(NewJSONRequest(service,"Registry.Deregister"))
      }
      func RegService(service *Service) error {
        return requestRegistry(NewJSONRequest(service,"Registry.Register"))
      }

    初始化代码
      service:=sidecar.NewService("api.jtthink.com.test")
	    service.AddNode("test-"+uuid.New().String(),8088,"192.168.29.1")

  测试调用外部api
    引入
      myhttp "github.com/micro/go-plugins/client/http“
    指定Registry
      etcdReg:=etcd.NewRegistry(registry.Addrs("192.168.29.135:23791"))
    创建Selector
      mySelector:=selector.NewSelector(   
        selector.Registry(etcdReg),   
        selector.SetStrategy(selector.RoundRobin),
      )
    创建client
      getClient:= myhttp.NewClient(client.Selector(mySelector),client.ContentType("application/json"))
      req:=getClient.NewRequest("api.jtthink.com.test","/v1/test",map[string]string{})

      var rsp map[string]interface{}
      err:=getClient.Call(context.Background(),req,&rsp)
      if err!=nil{
        log.Fatal(err)
      }
      fmt.Println(rsp)