https://github.com/go-kit/kit 

是一个微服务工具包合集。利用它提供的API和规范可以创建健壮、可维护性高的微服务体系

https://godoc.org/github.com/go-kit/kit（文档以及一些列子）

安装: go get github.com/go-kit/kit 

也有一些框架如：
https://github.com/micro/go-micro
https://github.com/koding/kite

微服务体系的基本需求
  1、 HTTP REST、RPC
  2、日志功能
  3 、限流
  4、 API监控
  5、服务注册与发现
  6、API网关
  7、服务链路追踪
  8、服务熔断

Go-kit的三层架构
  1、Transport 
    主要负责与 HTTP、gRPC、thrift等相关的逻辑

  2、Endpoint
    定义Request 和Response格式，并可以使用装饰器包装函数，以此来实现各种中间件嵌套。

  3、Service
    这里就是我们的业务类、接口等

第一步:创建接口以及实现
  type IUserService interface {
    GetName(userid int) string
  }
  //////以下是实现类
  type UserService struct {}
  func(this *UserService) GetName(userid int) string  {
    if userid==101{ //这里假设模拟从数据库取
      return "shenyi"
    }
    return "guest"
  }

第二步:创建EndPoint
  type UserRequest struct {
    Uid  int `json:"uid"`
  }
  type UserResponse struct {
    Result string `json:"result"`
  }

  func GenUserEndpoint(service IUserService ) endpoint.Endpoint  {
    return func(ctx context.Context, request interface{}) (response interface{}, err error){
      r:=request.(UserRequest)
      res:=service.GetName(r.Uid)
      return UserResponse{Result:res},nil
    }
  }

第三步:创建Transport
  当我们外部有请求过来时， 我们需要对Request进行decode
  注意：外部请求很可能是rpc、http。参数形式也许是json也许就是赤裸裸的url参数
  func DecodeUserRequest(c context.Context, r *http.Request) (interface{}, error){
    if r.URL.Query().Get("uid")!=""{
      uid,_:=strconv.Atoi(r.URL.Query().Get("uid"))
      return UserRequest{
        Uid:uid,
      },nil
    }
    return nil,errors.New("参数错误")
  }

  对于响应：响应是我们发出的,我们需要encode，比较通用且简单的就是json
  func EncodeUserResponse(ctx context.Context, w http.ResponseWriter, response interface{}) error {
    //w.Header().Set("Content-Type", "application/json;charset=utf-8")
    return json.NewEncoder(w).Encode(response)
  }

user:=Services.UserService{} //第一步
endp:=Services.GenUserEnpoint(user)
ServerHandler:=httptransport.NewServer(endp,Services.DecodeUserRequest,Services.EncodeUserResponse) //第二步
http.ListenAndServe(“:8080”,ServerHandler) //第三步：发布服务

第三方路由
  https://github.com/gorilla/mux

  mux:=mymux.NewRouter()
  mux.Handle("/user/{uid:\\d+}",serverHanlder)

  Transport修改
    vars:=mymux.Vars(r)
    if uid,ok:=vars["uid"];ok{
      uid,_:=strconv.Atoi(uid)
        return UserRequest{
          Uid:uid,
        },nil
    }

服务注册
  consul
    服务管理软件。支持多数据中心下，分布式高可用的，服务发现和配置共享, 成员管理和消息广播,支持ACL访问控制。(相关的其他软件类似Zookeeper，Etcd、spring cloud 里面的eureka)

    文档地址：
      https://www.consul.io/api/index.html

    使用docker部署consul(单点)
      docker pull consul

    启动一个服务端
      docker run -d --name=cs -p 8500:8500  \
        consul agent -server -bootstrap  -ui -client 0.0.0.0

      -server 代表以服务端的方式启动
      -boostrap 指定自己为leader，而不需要选举
      -ui 启动一个内置管理web界面
      -client 指定客户端可以访问的IP。设置为0.0.0.0 则任意访问，否则默认本机可以访问

      8500是后台UI端口，别忘了sudo iptables -I INPUT -p tcp --dport 8500 -j ACCEPT
    
    查看当前所有服务
      http://192.168.29.128:8500/v1/agent/services

    手工注册一个服务
      首先启动自己的本地服务并确保虚拟机上能访问，然后增加一个/health 输出{“status”:”OK”} 即可（注意JSON 头要加）

      创建一个文件
        {
          "ID": "userservice",
          "Name": "userservice",
          "Tags": [
            "primary"
          ],
          "Address": "192.168.29.1",
          "Port": 8080,
          "Check": {
            "HTTP": "http://192.168.29.1:8080/health",
            "Interval": "5s"
          }
        }

      提交服务
        curl \
          --request PUT \
          --data @p.json \
          localhost:8500/v1/agent/service/register

      反注册
        curl \
          --request PUT \
          http://localhost:8500/v1/agent/service/deregister/userservice

  使用go向Consul注册服务
    下载客户端库
      go get github.com/hashicorp/consul

    参考文档
      1、https://github.com/hashicorp/consul/tree/master/api
      2、https://godoc.org/github.com/hashicorp/consul/api （主要是这个）

    第一步：创建一个config和基于 config的client
      consulapi "github.com/hashicorp/consul/api"
      
      config := consulapi.DefaultConfig()
      config.Address="192.168.29.128:8500“  
      client,err:=consulapi.NewClient(config)
      if err!=nil{
        log.Fatal(err)
      }

    第二步 创建 AgentServiceRegistration ，并指定ID、地址之类的东西
      reg:=consulapi.AgentServiceRegistration{}
      reg.ID="userservice"
      reg.Name="userservice"
      reg.Address="192.168.29.1"
      reg.Port=8080
      reg.Tags=[]string{"primary"}

    第三步 创建 健康检查(check)，并指定一些参数
      check:=consulapi.AgentServiceCheck{}
      check.HTTP="http://192.168.29.1:8080/health"
      check.Interval="5s"
      reg.Check=&check
    
    第四步 注册
      err=client.Agent().ServiceRegister(&reg)
      if err!=nil{
        log.Fatal(err)
      }

  Go退出时向Consul反注册服务的基本方法、优雅关闭服务
    var ConsulClient *consulapi.Client
    func init()  {  //引入包时自动执行
      config:=consulapi.DefaultConfig()
      config.Address="192.168.29.128:8500"
      client,err:=consulapi.NewClient(config)
      if err!=nil{
        log.Fatal(err)
      }
      ConsulClient=client
    }

    var ConsulClient *consulapi.Client
    func init()  {  //引入包时自动执行
      config:=consulapi.DefaultConfig()
      config.Address="192.168.29.128:8500"
      client,err:=consulapi.NewClient(config)
      if err!=nil{
        log.Fatal(err)
      }
      ConsulClient=client
    }

    go(func() {
      c:=make(chan os.Signal,1)
      signal.Notify(c,syscall.SIGINT,syscall.SIGTERM)
      errchan <- fmt.Errorf("%s",<-c)
    })()

    getErr:= <- errchan
    util.Unregservice()
    log.Println(getErr)

服务发现
  客户端直接调用服务（直连方式）
    httpclient 既然有NewServer，同时gokit还帮我们封装了一个client对象
      httptransport.NewClient(method,target,enc,dec)

      1、method  请求方式
      2、target 请求url  譬如 http://localhost:8080   (注意 ：不带path)
      3、enc
        type EncodeRequestFunc func(context.Context, *http.Request, interface{}) error
        请求Encode 

        dec
        type DecodeResponseFunc func(context.Context, *http.Response) (response interface{}, err error)
        获得响应后如何处理

    服务地址是：
      http://localhost:8080/user/101
    我们要获取用户信息  
      1、target 就是http://localhost:8080
      2、path就是 /user/xxxx

    EncodeRequestFunc
      func GetUserInfo_Request(c context.Context,req *http.Request,r interface{}) error{
        user_request:=r.(UserRequest)
        req.URL.Path+="/user/"+strconv.Itoa(user_request.Uid)
        return nil
      }

    DecodeUserResponse
      func GetUserInfo_Response(c context.Context, res *http.Response) (response interface{}, err error){
        var user_response UserResponse
        if res.StatusCode>400{
          return nil,errors.New("no data")
        }
        err=json.NewDecoder(res.Body).Decode(&user_response)
        if err!=nil{
          return nil,err
        }
        return user_response,nil
      }

    tart,_:=url.Parse("http://localhost:8080")
    endpoint:= httptransport.NewClient("GET",tart,GetUserInfo_Request,GetUserInfo_Response).Endpoint()
    ctx:=context.Background()
    res,_:=endpoint(ctx,UserRequest{Uid:123})
    userres:=res.(UserResponse)
    fmt.Println(userres.Result)

  通过服务中心取分几步
    第一步：
      使用前面的consul api创建一个client,然后go-kit的sd包，帮我们封装好了一个专门client
      别忘了 import consulapi "github.com/hashicorp/consul/api"
      config:=consulapi.DefaultConfig()
      config.Address=“192.168.29.128:8500“ //注册中心的地址
      这里需要import github.com/go-kit/kit/sd/consul
      api_client,_:=consulapi.NewClient(config)
      client:=consul.NewClient(api_client)
    
    第二步 创建一个instancer
      var logger log.Logger
      {
        logger = log.NewLogfmtLogger(os.Stdout)
      }
      {
        tags:=[]string{"primary"}
        //可实时查询服务实例的状态信息
        instancer:=consul.NewInstancer(client,logger,"userservice",tags,true)
      }

    第三步：创建EndPointer
      f:=func(instance string) (endpoint.Endpoint, io.Closer, error) {
        tart,_:=url.Parse(“http”instance)
        return httptransport.NewClient("GET",tart,GetUserInfo_Request,GetUserInfo_Response).Endpoint(),nil,nil
      }
      endpointer:=sd.NewEndpointer(instancer,f,logger)
      EndPointer可以用来获取所有的Endpoint

    第四步：循环获取服务
      endpoints,_:=endpointer.Endpoints()
      for _,getPoint:=range endpoints{
        ctx:=context.Background() //第三步：创建一个context上下文对象
        ////第四步：执行
        res,err:=getPoint(ctx,UserRequest{Uid:101})
        if err!=nil{
          fmt.Println(err)
          continue
          }
        fmt.Println(res)
      }

    根据命令行参数注册多个服务
      Golang专门有个flag包，用来方便的获取参数
      name:=flag.String("name","","服务名称")
      这样就可以使用 go run xxxx.go -name=xxxoo 
      以下这种形式都可以
        -id=1
        --id=1
        -id 1
        --id 1
      
      获取参数
        name:=flag.String("name","","服务名称")
        port:=flag.Int("p",0,"服务端口")
        flag.Parse()
        if *name==""{
          log.Fatal("请指定服务名")
        }
        if *port==0{
          log.Fatal("请指定端口")
        }
        util.SetServiceName(*name)
        util.SetServicePort(*port)
    
    使用负载均衡的方式调用服务(轮询方式)
      分别执行
        go run main.go -name userservice -p 8082
        go run main.go -name userservice -p 8083
      
      负载均衡(RoundRobin)
        mylb:=lb.NewRoundRobin(endpointer)

      负载均衡(随机算法)
        mylb:=lb.NewRandom(endpointer,time.Now().UnixNano())

API限流
  go内置的rate
    Go 提供了一个内置限流包 golang.org/x/time/rate，可以非常方便的实现限流
    一般市面上常用的限流算法有漏桶和令牌桶两种
    
    核心三个方法
      Wait/WaitN   
        桶容量为b, 灌满，以后每次往里面填充r个令牌。(这个r就是速率)
        r:=rate.NewLimiter(1,5) //第二个参数是容量(b)， 第一个每次放几个(r)
        fmt.Println(r.Limit(),r.Burst())
        这两个函数可以查看设置好的参数

        ctx,_:=ctx:=context.Background()
          for {
          err := r.Wait(ctx) //你可以写成 r.WaitN(ctx,1)
          if err!=nil{
            fmt.Println(err)
          }
          time.Sleep(time.Second)
          fmt.Println(time.Now().Format("2006-01-02 15:04:05"))
        }

      Allow/AllowN 
        使用go-kit里面的Middleware包裹
        func RateLimit(limit * rate.Limiter) endpoint.Middleware  {
          return func(i endpoint.Endpoint) endpoint.Endpoint {
            return  func(ctx context.Context, request interface{}) (response interface{}, err error){
              if !limit.Allow(){
                return nil,errors.NewError(429,“too many")
              }
              return i(ctx,request)
            }
          }
        }

        Main函数
        limit:=rate.NewLimiter(rate.Every(time.Second*1),3)
        endp:=RateLimit(limit)(GenUserEndpoint(user))//

      Reserve/ReserveN 
    
统一异常处理
  初始化参数
    options := []httptransport.ServerOption{
      httptransport.ServerErrorEncoder(MyErrorEncoder),
    }

    func MyErrorEncoder(_ context.Context, err error, w http.ResponseWriter) {
      contentType, body := "text/plain; charset=utf-8", []byte(err.Error())
      w.Header().Set("Content-Type", contentType)
      w.WriteHeader(500)
      w.Write(body)
    }

  创建一个struct
    type MyError struct {	
      Code int	
      Message string
    }
  
  实现方法
    func(this *MyError) Error() string  
    {
      return this.Message
    }
  
  New函数
    func NewError(message string,code int ) error {
      return &MyError{Code:code,Message:message}
    }

熔断器
  使用hystrix设置command和超时
    config:=hystrix.CommandConfig{
			Timeout:5000,
		}
		hystrix.ConfigureCommand("getProd",config)
    err:=hystrix.Do("getProd", func() error {
      p,_:=getProduct() //这里会随机延迟三秒
      fmt.Println(p)
      return nil
    },nil)

    if err!=nil{
      fmt.Println(err)
    }

  异步执行和服务降级
    Do方法是同步方法。还有个方法是Go方法，内部会开一个协程来处理

  控制最大并发数

  熔断器的打开与参数设置
    设置熔断器参数
      RequestVolumeThreshold:5,
      ErrorPercentThreshold:20,

      RequestVolumeThreshold:默认20 。熔断器请求阀值，意思是有20个请求才进行 错误百分比计算
      ErrorPercentThreshold：就是错误百分比。默认50（50%）

  熔断器的三种状态、状态获取
    关闭： 默认状态。如果请求次数异常超过设定比例，则打开熔断器
    打开：当熔断器打开的时候，直接执行降级方法。
    半开：定期的尝试发起请求来确认系统是否恢复。如果恢复了，熔断器将转为关闭状态或者保持打开

    SleepWindow :熔断器打开后，过多久后去尝试服务是否可用。默认5秒

  熔断器部署
    configA:=hystrix.CommandConfig{
      Timeout:2000,
      MaxConcurrentRequests:5,
      RequestVolumeThreshold:3,
      ErrorPercentThreshold:20,
      SleepWindow:int(time.Second*100),
    }
    hystrix.ConfigureCommand("getuser",configA)
    err:=hystrix.Do("getuser", func() error {
      res,err:=util.GetUser()
      fmt.Println(res)
      return err
    }, func(e error) error {
      fmt.Println("降级用户")
      return e
    })
    if err!=nil{
      fmt.Println("错误信息",err)
    }

日志
  初始化
    var logger log.Logger
		{
			logger = log.NewLogfmtLogger(os.Stdout)
		}

  logger.Log("Method",r.Method,"event","get user","uid",r.Uid)
  它会输出Method=GET event="get user" uid=1

  加入两个固定输出
    logger = log.With(logger, "ts", log.DefaultTimestampUTC)
    logger = log.With(logger, "caller", log.DefaultCaller)

  使用中间件的方式包装日志输出
    初始化
      func UserServiceLogMidleWare(logger log.Logger) endpoint.Middleware  {
        return func(next endpoint.Endpoint) endpoint.Endpoint {
          return func(ctx context.Context, request interface{}) (response interface{}, err error){
            r:=request.(UserRequest)
            logger.Log("method",r.Method,"event","get user","userid",r.Uid)
            return next(ctx,request)
          }
        }
      }
    
    在main部分初始化
      var logger kitlog.Logger
      {
        logger = kitlog.NewLogfmtLogger(os.Stdout)
        logger=kitlog.WithPrefix(logger,"mykit","1.0")
        logger=kitlog.With(logger,"time",kitlog.DefaultTimestampUTC)
        logger=kitlog.With(logger,"caller",kitlog.DefaultCaller)
      }

Jwt集成
  https://github.com/dgrijalva/jwt-go

  文档参考：
    https://godoc.org/github.com/dgrijalva/jwt-go#example-New--Hmac

  对称加密
    sec:=[]byte("123abc")
    token_obj := jwt.NewWithClaims(jwt.SigningMethodHS256, UserClaim{})
    token,_:=token_obj.SignedString(sec)
    fmt.Println(token)

    验证
      getToken,_:=jwt.Parse(token,func(token *jwt.Token) (i interface{}, e error) {
        return sec,nil
      })
      if getToken.Valid{
        fmt.Println(getToken.Claims)
      }

    验证(还原类型) 
      uc:=UserClaim{}
      getToken,_:=jwt.ParseWithClaims(token,&uc,func(token *jwt.Token) (i interface{}, e error) {
        return sec,nil
      })
      if getToken.Valid{
        fmt.Println(getToken.Claims.(*UserClaim))
      }

  非对称加密

  token设置过期时间、异常判断
    user:=UserClaim{Uname:"shenyi"}
    user.ExpiresAt=time.Now().Add(time.Second*10).Unix()  //这里需要转为unix时间戳

    判错处理
      else if ve, ok := err.(*jwt.ValidationError); ok {
			  if ve.Errors&jwt.ValidationErrorMalformed != 0 {
				  fmt.Println("错误的token")
			  } else if ve.Errors&(jwt.ValidationErrorExpired|jwt.ValidationErrorNotValidYet) != 0 {

				  fmt.Println("token过期或未启用")
			  } else {
				  fmt.Println("Couldn't handle this token:", err)
			  }
		  } else {
			  fmt.Println("无法解析此token", err)
		  }

  请求tokenAPI、中间件的方式集成token认证、存放用户信息
    JSON第三方库
      github.com/tidwall/gjson

    中间件核心代码
      r:=request.(UserRequest)
			uc:=UserClaim{}
			getToken,err:= jwt.ParseWithClaims(r.Token,&uc, func(token *jwt.Token) (i interface{}, e error) {
				return []byte(secKey),nil
			})
			if getToken!=nil &&getToken.Valid{
				 newCtx:=context.WithValue(ctx,"userinfo",getToken.Claims.(*UserClaim))
				return next(newCtx,request)
			}  else {
				return nil,util.NewMyError(403,"error token")
			}
