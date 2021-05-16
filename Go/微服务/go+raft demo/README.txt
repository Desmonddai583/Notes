使用第三方库
  https://github.com/hashicorp/raft raft协议的go实现
  https://github.com/hashicorp/raft-boltdb  一个嵌入式的kv数据库 用于raft协议实现中的节点保存和数据快照保存

创建一个raft节点
  node,err:=raft.NewRaft(各种参数)

参数
  config:节点的基本配置，包含了日志、选举超时、快照保存频率等等
    config:=raft.DefaultConfig()
    config.LocalID="1"
    config.Logger=hclog.New(&hclog.LoggerOptions{
      Name:  "myraft",
      Level: hclog.LevelFromString("DEBUG"),
      Output:os.Stderr,
    })
  
  LogStore: 存储日志 （任期、command等）
    dir,_:=os.Getwd()
    root:=strings.Replace(dir,"\\","/",-1)
    log_store,err:=raftboltdb.NewBoltStore(root+"/n1/log_store.bolt")
    if err!=nil{
      log.Fatal(err)
    }

  StableStore: 存储节点信息
    stable_store,err:=raftboltdb.NewBoltStore(root+"/n1/stable_store.bolt")
    if err!=nil{
      log.Fatal(err)
    }

  Transport: 各个节点之间的通信方式(一般采用tcp)
    addr,err:=net.ResolveTCPAddr("tcp","127.0.0.1:3000")
    transport,err:=raft.NewTCPTransport(addr.String(),addr,5,time.Second*10,os.Stdout)
    if err!=nil{
      log.Fatal(err)
    }

  SnapshotStore: 存储节点数据的快照信息
    DiscardSnapshotStore：  不存储 
    FileSnapshotStore：        文件 存储
    InmemSnapshotStore：   内存存储

    为了测试，我们暂时采用不存储
    snapshotStore:=raft.NewDiscardSnapshotStore()

  FSM finite state machine，有限状态机
    主要用于 apply数据的方式、快照恢复等等。需要自己写类
    type MyFsm struct {
    }
    func(this *MyFsm) Apply(log *raft.Log) interface{}{
      return nil
    }
    func(this *MyFsm) Snapshot() (raft.FSMSnapshot, error){
      return nil,nil
    }
    func(this *MyFsm) Restore(io.ReadCloser) error{
      return nil
    }

启动
  configuration := raft.Configuration{
		Servers: []raft.Server{
			{
				ID:      "1",
				Address: transport.LocalAddr(),
			},
		},
	}
  raftnode.BootstrapCluster(configuration)

简单缓存接口、多节点数据复制
  Set接口
    jsonBytes, _ := json.Marshal(req)
		future:=RaftNode.Apply(jsonBytes,time.Second)
		if e:=future.Error();e!=nil{
			Error(e)
		}
  FSM部分
    req:=NewCacheRequest()
    err:=json.Unmarshal(log.Data,req)
    Set(req.Key,req.Value)

强制使用leader来提供服务
  简易判断函数
    //判断自己是不是leader
    func IsLeader() bool {
      if string(RaftNode.Leader())==SysConfig.Transport{
        return true
      }
      return false
    }
    //得到leader的http地址
    func GetLeaderHttp() string   {
      for _,s:=range SysConfig.Servers{
        if string(s.Address)==string(RaftNode.Leader()){
          return s.Http
        }
      }
      return ""
    }

  反向代理
    if IsLeader(){
      context.Next()
    }else{
      http:=GetLeaderHttp()
      addr,_:=url.Parse(http)
      log.Println("leader地址是:",addr)
      p:=httputil.NewSingleHostReverseProxy(addr)
      p.ServeHTTP(context.Writer,context.Request)
      context.Abort()	
    }

KV存储第三方库使用
  RocksDB
    基于Google 的 leveldb嵌入式高性能Key-value存储系统。
    众所周知的TiDB的TIKV就是基于RocksDB实现。是c++写的，使用起来尤其是windows使用不是很方便

  Go替代品：Badger
    使用Go编写的可嵌入的KV数据库。它是Dgraph的基础数据库，Dgraph是一种快速的分布式图形数据库。它旨在成为RocksDB等非基于Go的KV存储高性能替代品。

   github地址：
    https://github.com/dgraph-io/badger
    安装：go get github.com/dgraph-io/badger/v2

  db,err:=badger.Open(
    badger.DefaultOptions("tmp/"),
  )

  缓存封装
    初始化
      func NewBcach(dir string ) *Bcach {
        db,err:=badger.Open(
          badger.DefaultOptions(dir),
        )
        if err!=nil{
          panic(err)
        }
        return &Bcach{DB:db}
      }

    SetItem
      func(this *Bcach) SetItem(key string,value string ) error {
        err:=this.Update(func(txn *badger.Txn) error {
          err:= txn.Set([]byte(key),[]byte(value))
            return err
        })
        if err!=nil{
          return err
        }
        return nil
      }

    GetItem
      func(this *Bcach) GetItem(key string) interface{}  {
        var ret interface{}
        err:=this.View(func(txn *badger.Txn) error {
          item,err:=txn.Get([]byte(key))
          if err!=nil{
            return err
          }
          return  item.Value(func(val []byte) error {
            ret=string(val)
            return nil
          })
        })
        if err!=nil{
          log.Println(err)
          return nil
        }
        return ret
      }

  本地KV和Redis进行的基准测试
    准备代码 (单例模式)
      var cache *lib.Bcache
      var cache_once sync.Once
      func getCache() *lib.Bcache{
        cache_once.Do(func() {
          cache=lib.NewBcache("../tmp")
        })
        return cache
      }

    基准测试代码(KV)
      func Benchmark_AddKV(t *testing.B){
        for i:=0;i<t.N;i++{
          key:=fmt.Sprintf("key%d",i)
          value:=key+"value"
          addKV(key,value)
        }
      }

    Redis
      用的是Redigo 第三方库
      go get github.com/gomodule/redigo
      本地启动 了一个 redis server 3.2

      准备代码 (单例模式)
        var rcache redis.Conn
        var rcache_once sync.Once
        func getRedisCache() redis.Conn{
          rcache_once.Do(func() {
            c, err := redis.Dial("tcp", "127.0.0.1:6379")
            if err != nil {
              fmt.Println("Connect to redis error", err)
              return
            }
            rcache=c
          })
          return rcache
        }

      测试代码
        func Benchmark_AddRedis(t *testing.B){
          for i:=0;i<t.N;i++{
            key:=fmt.Sprintf("key%d",i)
            value:=key+"value"
            _,err:=getRedisCache().Do("set",key,value)
            if err!=nil{
              log.Println("redis set error",err)
            }
          }
        }

    执行测试
      go test -bench=. 

本地KV和Raft整合
  1、去掉快照
  2、重建向量机，处理数据的插入
  3、修改配置文件，加入kv文件的保存路径

  测试方式
    查询
    Post http://localhost:8081/get
    {    "key":"name"}

    新增
    POST http://localhost:8081/set
    {    "key":"name",    "value":"shenyi"}

手撸配置中心
  存储key的设计
    group 
    代表是分组

    data Id 
    代表是配置的唯一ID

    version
    版本。默认v1

    /group/dataid/v1

  /group/data id/version
  {
    desc: 描述内容
    md5 : 自动生成
    content:配置内容
  }  

  构建两个(类)
    type ConfigSet struct {
      Desc string
      Md5 string
      Content string
    }
    type ConfigService struct {
        Group string
        DataId string
      Version string
        Config *ConfigSet
    }

  使用Protobuf序列化配置信息内容
    GO的protobuf库 （程序调用）
      https://github.com/golang/protobuf
      go get github.com/golang/protobuf
    protc 编译工具 
      https://github.com/protocolbuffers/protobuf/releases
    Go编译插件
      https://github.com/protocolbuffers/protobuf-go

    编写Proto文件
      syntax = "proto3";
      option go_package = ".;configsvr";
      message ConfigSet {
          string desc = 1;
          string md5 = 2;
          string content = 3;
      }

    在项目根目录下执行：
      protoc --proto_path=src/protos --go_out=src/configsvr ConfigSet.proto

系统API
  取值API
    GET /diamond-server/config.co?dataId=xxx&group=xxx&version=xxx
  增加API
    POST /diamond-server/basestone.do
  取所有配置
    GET /diamond-server/basestone.do

  请求实体
    type RequestGet struct {
      DataId string `form:"dataId" binding:"required,min=2"`
      Group string `form:"group" binding:"required,min=2"`
      Version string `form:"version" binding:"required,min=2"`
    }

  http代码
    func ConfigHttp()  *gin.Engine {
      r:=gin.Default()
      r.Use(lib.CacheMiddleware())
      g:=r.Group("diamond-server")
      g.Handle("GET","/config.co", func(context *gin.Context) {
        req:=&RequestGet{}
        lib.Error(context.BindQuery(req))
        cs:=NewConfigService(req.Group,req.DataId,req.Version,nil)
        lib.Error(cs.Load())
        context.JSON(200,cs.Config)
      })
      return r
    }

  Load函数
    func(this * ConfigService) Load() error{
      b,err:=lib.LocalCache.GetItem(this.Key())
      if err!=nil{
        return err
      }
      err=proto.Unmarshal(b,this.Config)
      if err!=nil{
        return err
      }
      return nil
    }
