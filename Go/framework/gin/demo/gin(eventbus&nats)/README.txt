因果关系
  用户请求/prods 是起因，结果 是：你输出商品列表给用户
  1、发生的事件：获取商品
  2、事件参数： 我们这没有。你可以认为是http 参数
  3、事件处理： 我们的Service函数完成了业务

利用go的channel完成
  type EventData struct {
    Data interface{}
  }
  type EventDataChanel chan *EventData

  EventBUS
    type EventBus struct {
      subscribes map[string]EventDataChanel
    }

    func NewEventBus( ) *EventBus {
      return &EventBus{subscribes: make(map[string]EventDataChanel)}
    }
    func(this *EventBus) Subscribe(topic string ) EventDataChanel{
      c:=make(chan *EventData)
        this.subscribes[topic]=c
        return c
    }
    func(this *EventBus) Publish(topic string,data interface{}){
        if c,found:=this.subscribes[topic];found{
          go func() {
            c<-&EventData{Data:data}
          }()
        } 
    }

加锁
  发布者主要是读,也就是读取Topic对应的channel,这里我们使用读锁定
  反过来我们的订阅者是写锁定 (因为需要写map)

设置超时
  func (this EventDataChannel) Data(timeout time.Duration) interface{} {
    ctx, cancle := context.WithTimeout(context.Background(), timeout)
    defer cancle()
    select {
    case <-ctx.Done(): //超时了
      return gin.H{"message": "timeout"}
    case data := <-this:
      return data
    }
  }

nats
  nats是一个开源的，云原生的消息系统。Apcera，百度，西门子，VMware，HTC和爱立信等公司都有在使用。
  原理是基于消息发布订阅机制，每台服务器上的每个模块会根据自己的消息类别向MessageBus发布多个消息主题，而同时也向自己需要交互的模块，按照需要的主题订阅消息。
  能够达到每秒8-11百万个消息，整个程序很小只有3M Docker image，它不支持持久化消息，如果你离线，你就不能获得消息。使用
  nats streaming可以做到持久化，缓存等功能。

  服务端
    https://github.com/nats-io/nats-server/releases/tag/v2.1.9

  客户端
    go get github.com/nats-io/nats.go/

  简单代码
    nc, _ := nats.Connect(nats.DefaultURL)
    defer nc.Close()
    err:=nc.Publish("test", []byte("hi"))
    if err!=nil{   
      log.Println(err)
    }

  主题格式
    nats中一般使用 “.” 来格式主题（topic）
    譬如 用户新增 一般我们写成users.add

  通配符--*
    nat.Subscribe("users.*", func(msg *nats.Msg) {
      fmt.Println(msg.Subject)
    })

  通配符-->
    箭头通配符 可以匹配 1 或以上的 主题 （写在末尾）
    譬如我们的主题是 users.add.admin 代表新增管理员. 那刚才的 * 通配符就无法匹配到
  
  使用protobuf传递服务调用数据
    go get github.com/golang/protobuf

    定义proto
      syntax = "proto3";
      option go_package = ".;models";
      message  UserModel {
        int32 UserId =1;   //传入的商品ID
        string UserName=2;
        int32 Score=3;
      }

    解析代码
      func(this *UserModel) Encode() []byte{
        b,_:=proto.Marshal(this)
        return b
      }
      func(this *UserModel)  Decode(b []byte) error{
        return proto.Unmarshal(b,this)
      }

  模式调整:增加中间消费者、gRpc接口
    首先把scoreapi变成grpc的
    go get github.com/golang/protobuf/protoc-gen-go 
    另外安装：go get google.golang.org/grpc 

  模式调整:微服务聚合接口