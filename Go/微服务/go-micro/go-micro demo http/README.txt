安装
  go get -u github.com/micro/go-micro

service := web.NewService(web.Address(":8080"))
service.Run()

服务注册
  拉取镜像(这里使用单机)
    docker pull consul

  启动一个服务端
    #docker run -d --name=cs -p 8500:8500  \
    consul agent -server -bootstrap  -ui -client 0.0.0.0

    -server 代表以服务端的方式启动
    -boostrap 指定自己为leader，而不需要选举
    -ui 启动一个内置管理web界面
    -client 指定客户端可以访问的IP。设置为0.0.0.0 则任意访问，否则默认本机可以访问。 
    8500是后台UI端口，别忘了sudo iptables -I INPUT -p tcp --dport 8500 -j ACCEPT

  构建一个注册器
    reg := consul.NewRegistry(
      registry.Addrs("192.168.29.135:8500"),
    )

  加入两行:
    server:=web.NewService(
      web.Name("prodservice"),
      web.Address(":8001"),
      web.Handler(ginRouter),
      web.Registry(reg),
    )

  获取consul服务列表、selector随机选择
    consulReg:=consul.NewRegistry(registry.Addrs("192.168.29.135:8500"))
    services,err:=consulReg.GetService("prodservice")
    if err!=nil{
      log.Fatal(err)
    }
    next:= selector.Random(services)
    node,err:=next()

  使用内置命令参数启动、注册多个服务
    Go-micro内置了一些参数，可以在启动时指定，这样就不用写死了
    go run prod_main.go --server_address :8001
    别忘了加上 server.Init()

  开启多个服务、用轮询方式获取服务
    @echo off
    start "prod1" go run prod_main.go --server_address :8001 &
    start "prod2" go run prod_main.go --server_address :8002 &
    start "prod3" go run prod_main.go --server_address :8003 
    pause

    把此文件保存为 prod.bat文件，这样我们就能同时启动3个服务进行注册

服务调用
  http api
    func callApi(addr string,path string,method string) (string, error){
      req,_:= http.NewRequest(method,"http://"+addr+path,nil)
      client:=http.DefaultClient
      res,err:=client.Do(req)
      if err!=nil{
          return "",err
      }
      defer res.Body.Close()
      getBody,err:=ioutil.ReadAll(res.Body)
      return string(getBody),nil
    }

  使用插件、调用http api
    https://github.com/micro/go-plugins
    这里面包含了很多go-micro可选插件。譬如服务注册中心要选择etcd、eureka等，就需要使用到插件

    http 包
      对应的http调用包：
        import myhttp "github.com/micro/go-plugins/client/http "
      此包除了有 http client基本功能，还支持Selector参数，自动选取服务，并支持json、protobuf等数据格式 

    创建选择器，并把 Registrys 注入
      s:=selector.NewSelector(
        selector.Registry(consulReg),
        selector.SetStrategy(selector.Random),
      )

      func callAPI2(s selector.Selector)  {
        cli:=myhttp.NewClient(
          client.Selector(s),
          client.ContentType("application/json"),
          )
        req:=cli.NewRequest("prodservice","/v1/prods",
          map[string]string{},
        )
        var rsp  map[string]interface{}
        err:=cli.Call(context.Background(),req,&rsp)
        if err!=nil{
          log.Fatal(err)
        }
        fmt.Println(rsp["data"])
      }

    带参数调用
      引入protobuf、生成参数和响应模型
      安装好protobuf以及protoc-gen-go工具
      go-micro也有个对应的插件
        go get github.com/micro/protoc-gen-micro

      编写proto文件
        首先创建一个文件夹叫做Models,在里面再创建一个protos子文件夹、再然后，创建一个文件叫做Prods.proto文件夹

        syntax = "proto3";
        package  Models;

        message ProdModel{
            int32 ProdID =1;
            string ProdName=2;
        }
        message ProdsRequest{
            int32 size=1;
        }
        message ProdListResponse{
            repeated ProdModel data=1;
        }
      
      生成
        cd Models/protos
        protoc  --micro_out=../ --go_out=../ Prods.proto
        cd .. && cd ..

    处理参数模型中的json tag不一致问题
      go get -u github.com/favadi/protoc-go-inject-tag
      
      修改批处理文件
        cd Models/protos
        protoc  --micro_out=../ --go_out=../ Prods.proto
        protoc-go-inject-tag -input=../Prods.pb.go
        cd .. && cd ..

      修改proto文件
        message ProdModel{
          // @inject_tag: json:"pid"
          int32 ProdID =1;
          // @inject_tag: json:"pname"
          string ProdName=2;
        }
    