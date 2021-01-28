etcd
  etcd是一个高可用的键值存储系统,场景主要是
  1、主要用于共享配置
  2、服务注册与发现
  3、分布式锁等
  etcd是由CoreOS开发并维护的,灵感来自于 ZooKeeper 等。它使用Go语言编写

环境搭建
  docker pull golang:1.12-alpine
  
  下载etcd https://github.com/etcd-io/etcd/releases

  创建文件夹
    mkdir -p etcd/conf etcd/data

  docker run -it  --name etcd  \
    -p 2379:2379 \
    -v /home/desmond/etcd:/etcd \
    golang:1.12-alpine sh

  docker cp etcd etcd:/usr/bin && docker cp etcdctl etcd:/usr/bin

  创建配置文件
    在宿主机/home/desmond/etcd/conf下创建如下内容，文件名 etcd.yml
      name: $(hostname -s)
      data_dir: /etcd/data
      listen-client-urls: http://0.0.0.0:2379

  启动etcd 
    1、docker exec -it etcd sh (进入容器)
    2、chmod +x /usr/bin/etcd  (增加可执行权限)
    3、etcd --version  查看版本
    4、etcd --config-file  /etcd/conf/etcd.yml

etcdctl 
  etcdctl是客户端工具
  由于历史原因，存在v2和v3版本

  1、设置环境变量
    export ETCDCTL_API=3

  2、查看 etcdctl version

  插入
    etcdctl put /user/101/name shenyi
    etcdctl put /user/101/age 19
  
  单个查询
    etcdctl get /user/101/name  
    etcdctl get /user/101/age   

  查询id为101的用户所有信息
    etcdctl get /user/101 --prefix

etcd集群的创建
  创建一个专门的docker网络 
    docker network  create etcdnet  --subnet 172.25.0.0/16  (使用的是bridge,指定了子网)

  再创建一个文件夹，叫做etcd2
    里面依然是 conf和data两个文件夹

  配置文件
    name: etcd1
    data-dir: /etcd/data
    listen-client-urls: http://172.25.0.101:2379, http://127.0.0.1:2379
    advertise-client-urls: http://172.25.0.101:2379
    listen-peer-urls: http://172.25.0.101:2380
    initial-advertise-peer-urls: http://172.25.0.101:2380
    initial-cluster: etcd1=http://172.25.0.101:2380,etcd2=http://172.25.0.102:2380
    initial-cluster-token: etcd-cluster-token
    initial-cluster-state: new

    name: etcd2
    data-dir: /etcd/data
    listen-client-urls: http://172.25.0.102:2379, http://127.0.0.1:2379
    advertise-client-urls: http://172.25.0.102:2379
    listen-peer-urls: http://172.25.0.102:2380
    initial-advertise-peer-urls: http://172.25.0.102:2380
    initial-cluster: etcd1=http://172.25.0.101:2380,etcd2=http://172.25.0.102:2380
    initial-cluster-token: etcd-cluster-token
    initial-cluster-state: new

  固化镜像
    docker run --name testgo -it \
      golang:1.12-alpine sh

    拷贝 docker cp etcd testgo:/usr/bin && docker cp etcdctl testgo:/usr/bin 

    重新构建镜像 docker commit testgo etcd:my

  创建容器1
    docker run -d  --name etcd1  \
      --network etcdnet \
      --ip 172.25.0.101 \
      -p 23791:2379 \
      -v /home/shenyi/etcd:/etcd \
      etcd:my  etcd --config-file  /etcd/conf/etcd.yml

  创建容器2
    docker run -d  --name etcd2  \
      --network etcdnet \
      --ip 172.25.0.102 \
      -p 23792:2379 \
      -v /home/shenyi/etcd2:/etcd \
      etcd:my  etcd --config-file  /etcd/conf/etcd.yml

Go调用etcd
  go get go.etcd.io/etcd/clientv3
  文档如下：
    https://godoc.org/go.etcd.io/etcd/clientv3

  基本代码
    config := clientv3.Config{
      Endpoints:[]string{“ xxxx"},  
      DialTimeout:10*time.Second,  
    }
  
    client,err := clientv3.New(config)
    if err != nil {
      panic(err)
    }
    defer client.Close()
    kv:=clientv3.NewKV(client)
    ctx:=context.Background()
    kv.Put(ctx,"/services/bc","dd")

  启动容器时固化环境变量
    docker run -d  --name etcd1  \
      --network etcdnet \
      --ip 172.25.0.101 \
      -p 23791:2379 \
      -e ETCDCTL_API=3 \
      -v /home/shenyi/etcd:/etcd \
      etcd:my etcd --config-file /etcd/conf/etcd.yml

    docker run -d  --name etcd2  \
      --network etcdnet \
      --ip 172.25.0.102 \
      -p 23792:2379 \
      -e ETCDCTL_API=3 \
      -v /home/shenyi/etcd2:/etcd \
      etcd:my  etcd --config-file  /etcd/conf/etcd.yml

租约
  lease和redis设置过期是有区别的
  首先要创建一个租约，并设置过期时间
  etcdctl lease grant 20  设置一个20秒的租约

  查看租约信息
    查看租约列表
      etcdctl lease list

    查看信息（剩余时间）
      etcdctl lease timetolive   xxxxxxx

    删除租约 
      etcdctl lease revoke   xxxxxxx

    保持租约始终存活
      etcdctl lease keep-alive xxxxx

  key和租约关联
    etcdctl put /user shenyi --lease=xxxxxooo 
    一旦租约过期，或被删掉,key就没了

    etcdctl lease timetolive xxxxxxx --keys 
    可以查看该租约下的所有key

服务注册
  就是往etcd中存入一个key ,value就是 这个服务的地址
    /services/product1/prouct
    /services/product2/prouct
    /services/user1/user

  创建一个api
    使用第三方路由 go get github.com/gorilla/mux

  基本代码
    r := mux.NewRouter()

    r.HandleFunc("/prod/{id:\\d+}", func(writer http.ResponseWriter, request *http.Request) {
      vars := mux.Vars(request)
      str:="get product byID:"+vars["id"]
      writer.Write([]byte(str))
    })
    http.ListenAndServe(":8081",r)

  定义基本结构
    type Service struct {
      client *clientv3.Client
    }
    func NewService() *Service  {
      config:=clientv3.Config{
        Endpoints:[]string{"192.168.29.133:23791","192.168.29.133:23792"},
        DialTimeout:10*time.Second,
      }
      client,_:=clientv3.New(config)
      return &Service{client:client}
    }

  启动服务的初步优雅性
    分别定义4个变量
      serviceID:="p1"
      serviceName:="productservice"
      serviceAddr:="192.168.29.1"
      servicePort:=8081

    把注册服务和启动API服务放到协程里
      go(func(){
        s.RegService(serviceID,serviceName,serviceAddr+strconv.Itoa(servicePort))/注册服务
        http.ListenAndServe(":"+strconv.Itoa(*port),router)
      })()
  
    监听信号：至少2个
      1、ctrl+c信号
      2、终止信号（15，好比kill xxxx）
      go(func() {
        sigc:=make(chan os.Signal)
        signal.Notify(sigc,syscall.SIGINT,syscall.SIGTERM)
      })()

    创建一个channel，专门用于传输error
      errChan:=make(chan error)
      一旦出现error则执行
      if err!=nil{
        errChan<-err
        return
      }
      或 errChan<-fmt.Errorf("%s",<-sigc)

  设置续租
    keepRes,err:=lease.KeepAlive(context.TODO(),leaseRes.ID)
    if err!=nil{
      return nil
    }
    go lisKeepAlive(keepRes) 
    return err

服务发现
  创建一个client.go
    type Client struct {
      client *clientv3.Client
    }
    func NewClient() *Client {
      config:=clientv3.Config{
        Endpoints:[]string{"192.168.29.133:23791","192.168.29.133:23792"},
        DialTimeout:10*time.Second,
      }
      client,_:=clientv3.New(config)
      return &Client{client:client}
    }

  测试方法
    func(this *Client) GetServices()  {
      kv:=clientv3.NewKV(this.client)
      res,err:=kv.Get(context.TODO(),"/services",clientv3.WithPrefix())
      if err!=nil {
        return nil,err
      }
      for _,item:=range res.Kvs{
          fmt.Println(string(item.Key),)
      }
    }
  
  解析服务
    func(this *Client) parseService( key []byte, value []byte)  {
      reg:=regexp.MustCompile("/services/(\\w+)/(\\w+)")
      if reg.Match(key){
        idandname:=reg.FindSubmatch(key)
        sid:=idandname[1]
        sname:=idandname[2]
        fmt.Println(string(sid),string(sname))
        this.Services=append(this.Services,&ServiceInfo{ServiceID:string(sid),
          ServiceName:string(sname),ServiceAddr:string(value)})
      }
    }

  根据服务名获取地址、优雅调用机制
    设计一个结构
      type Endpoint func(ctx context.Context, request interface{}) (response interface{}, err error)
      type EncodeRequestFunc func(context.Context, *http.Request, interface{}) error
      
      Endpoint代表是端点。其实就是一个如何去执行服务调用的基本函数
      EncodeRequestFunc 也是一个函数，是用户自定义的，用来决定到底怎么传参数、调用具体哪个path

    基本函数
      func(this *Client) GetService(sname string,method string,encodeFunc EncodeRequestFunc) Endpoint  {
        for _,service:=range this.Services{
          if service.ServiceName==sname{
            return func(ctx context.Context, request interface{}) (response interface{}, err error) {
              httpRequest,err:= http.NewRequest(method,"http://"+service.ServiceAddr,nil)
            
              err=encodeFunc(ctx,httpRequest,request)
              
              httpClient := &http.Client{}
              httpResponse,err:=httpClient.Do(httpRequest)
              
              defer httpResponse.Body.Close()
              body,err:=ioutil.ReadAll(httpResponse.Body)
              
              return string(body),nil
            }
          }
        }
        return nil 
      }

  同时注册多个服务进ETCD
    服务ID用到第三方库
      go get -u github.com/satori/go.uuid
    代码修改点(服务端)
      name:=flag.String("name","","服务名称")
      port:=flag.Int("p",0,"服务端口")
      flag.Parse()
      if *name==""{
        log.Fatal("请指定服务名")
      }
      if *port==0{
        log.Fatal("请指定端口")
      }
    启动方式
      go run p1.go -name productservice -p 8081
      go run p1.go -name productservice -p 8082
    启动脚本(win)
      @echo off
      start "productservice1" go run p1.go -name productservice -p 8081 &
      start "productservice2" go run p1.go -name productservice -p 8082
      pause
    随机算法
      func(this *LoadBalance) SelectForRandom() *HttpServer {
        rand.Seed(time.Now().UnixNano())
        i:=rand.Intn(2)
        return this.Servers[i]
      }

配置中心
  Confd 一款高可用统一配置管理工具(go编写)
  https://github.com/kelseyhightower/confd

  Confd环境搭建
    Dockerfile文件
      FROM golang:1.12-alpine  as confd
      ARG CONFD_VERSION=0.16.0
      ADD https://github.com/kelseyhightower/confd/archive/v${CONFD_VERSION}.tar.gz /tmp/
      RUN apk add --no-cache \
          bzip2 \
          make && \
        mkdir -p /go/src/github.com/kelseyhightower/confd && \
        cd /go/src/github.com/kelseyhightower/confd && \
        tar --strip-components=1 -zxf /tmp/v${CONFD_VERSION}.tar.gz && \
        go install github.com/kelseyhightower/confd && \
        rm -rf /tmp/v${CONFD_VERSION}.tar.gz
      ENTRYPOINT ["/go/bin/confd"]

    生成 docker build -t confd:my . 

    在etcd里面插值
      插入以下两个值
        #etcdctl put /myconfig/mysql/user root
        #etcdctl put /myconfig/mysql/pass 123123

    配置
      参考文档： https://github.com/kelseyhightower/confd/blob/master/docs/quick-start-guide.md
      配置文件默认在 /etc/confd/ 

      首先创建一个文件夹叫做confdfiles,里面分别创建两个文件夹conf.d和templates
      其中conf.d 放配置文件，templates 放模板文件
        mkdir -p /home/shenyi/confdfiles/{conf.d,templates,dest}

      配置文件
        在conf.d里面创建一个配置叫做myconfig.toml
          [template]
          src = "myconfig.conf.tmpl"
          dest = "/etc/confd/dest/myconfig.conf"
          keys = [
            "/myconfig/mysql/user",
            "/myconfig/mysql/pass",
          ]

      模板文件
        在templates里面创建一个文件叫做myconfig.conf.tmpl
          [this is myconfig]
          database_user= {{getv "/myconfig/mysql/user"}}
          database_pass = {{getv "/myconfig/mysql/pass"}}

      运行容器
        docker run -it --rm  --name confd \
          -v /home/shenyi/confdfiles:/etc/confd \
          confd:my\
          -interval 5 -backend etcdv3 -node http://192.168.29.135:23792

        注意如果iptables开启了，那么etcd映射出来的端口要开放
        譬如 sudo iptables -I INPUT -p tcp --dport 23792 -j ACCEPT
  
  http服务读取配置文件、交叉编译
    第三方库
      go get gopkg.in/ini.v1

    交叉编译
      如果代码是在windows上写的，放到linux中需要交叉编译
        set GOARCH=amd64
        set GOOS=linux
        go build xxx.go

    在win下写了写了一个最简单的go http server，写了一个最简单的go http server,利用交叉编译出可执行程序，上传到了Linux里
    启动命令: ./myhttp -p 8002

    把配置写入etcd ，然后让confd来生成
    进入ectd容器，执行
      etcdctl put /myconfig/mygo/db_user shenyi
      etcdctl put /myconfig/mygo/db_pass 123456

    创建一个模板文件 my.ini.conf.tmpl
      [db]
      db_user={{getv "/mygo/db_user"}}
      db_pass = {{getv "/mygo/db_pass"}}

    编写配置文件
      创建一个配置文件 my.ini.toml
      [template]
      prefix="/myconfig"
      src = "my.ini.conf.tmpl"
      dest = "/mygo/my.ini"
      keys = [
        "/mygo/db_user",
        "/mygo/db_pass",
      ]

    启动容器
      -watch会监听key的值变化
      docker run -d   --name confd \
        -v /home/shenyi/confdfiles:/etc/confd \
        -v /home/shenyi/mygo:/mygo \
        confd:my \
        -watch  -backend etcdv3 -node http://192.168.29.135:23792

    做个API，当访问这个API时，重新加载配置文件
      mux.HandleFunc("/reload",func(writer http.ResponseWriter, request *http.Request) {
        newCFG,_:=ini.Load("my.ini")
        cfg=newCFG
      })

    改成自动的
      reload_cmd = "curl http://192.168.29.135:8001/reload"

    镜像需要安装curl
      由于用的容器是alpine的。纯净的，不带curl
      因此需要进入容器安装（安装好后可以commit更新镜像，这里就不演示了）
      几个步骤
        # docker exec -it confd sh 
        # echo http://mirrors.ustc.edu.cn/alpine/v3.7/main > /etc/apk/repositories && \
          echo http://mirrors.ustc.edu.cn/alpine/v3.7/community >> /etc/apk/repositories
        # apk add curl

  流程总结
    1、我们在win下写了一个最简单的go http server
    2、功能就是读取配置文件 然后显示在网页上
    3、利用交叉编译出可执行程序，上传到了Linux里
    4、启动命令: ./myhttp -p 8002
    5、然后利用confd生成出配置文件
    6、confd一旦watch到key值变化了，立刻生成新配置文件
    7、使用confd的reload_cmd完成触发

  取文件md5值
    func getFileMD5(filePath string ) (string,error)  {
      file, err := os.Open(filePath)
      hash := md5.New()
      if _, err = io.Copy(hash, file); err != nil {
        return "",err
      }
      hashInBytes := hash.Sum(nil)[:16]
      return hex.EncodeToString(hashInBytes),nil
    }

  配置文件变化后自动平滑重启http server
    go get -u github.com/jpillora/overseer

    基本代码
      定义回调
        type prog func(state overseer.State)

      实现函数
        prog:= func(state overseer.State) {
          server.Serve(state.Listener)
        }

    启动代码
      overseer.Run(overseer.Config{
        Program: prog,
        Address:":"+strconv.Itoa(*port),
      })
