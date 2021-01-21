RabbitMQ
  MQ使用了AMQP协议,属于应用层协议
  RabbitMQ(erlang编写)是AMQP的实现者

  docker镜像
    注意：management代表是带管理后台的
    docker pull rabbitmq:3.8-management-alpine 

  启动容器
    docker run -d  --name rmq \
      -e RABBITMQ_DEFAULT_USER=shenyi \
      -e RABBITMQ_DEFAULT_PASS=123 \
      -p 8080:15672 \
      -p 5672:5672 \
      rabbitmq:3.8-management-alpine

  go客户端库
    go get github.com/streadway/amqp

  初始化代码
    dsn := fmt.Sprintf("amqp://%s:%s@%s:%d/", "shenyi", "123", "192.168.29.135", 5672)
    conn, err := amqp.Dial(dsn)
    if err!=nil{
      log.Fatal(err)
    }
    defer conn.Close()

  初始化步骤
    1、申明队列
    2、创建Exchange
    3、绑定路由key

  消费者
    1、接收消息
    2、处理消息
    3、Ack确认

  开启confirm模式
    1、开启Confirm模式
      this.Channel.Confirm(false)

    2、并在Struct中加入属性
      notifyConfirm chan amqp.Confirmation

      发送消息后，当服务器确认此chan会有数据传输过来
      this.notifyConfirm=this.Channel.NotifyPublish(make(chan amqp.Confirmation))
    
    3、监听(一次性)
      select {
      case confirm := <-this.notifyConfirm:
        if confirm.Ack {
          log.Println("publish confirmed!")
        }else {
          log.Println("publish error")
        }
      }
      defer this.Channel.Close()
  
  消息入列回执 NotifyReturn的用法
    参数mandatory
      如果为true，在exchange正常且可到达的情况下。如果exchange+routeKey无法投递给queue，那么MQ会将消息返还给生产者;
      如果为false时，则直接丢弃

    开启
      func(this *MQ) NotifyReturn ()  {
        this.notifyReturn=this.Channel.NotifyReturn(make(chan amqp.Return))
        go this.ListReturn()
      }
      
      func(this *MQ) ListReturn(){
        ret:=<-this.notifyReturn
        log.Println("消息没有投递到队列:",string(ret.Body),ret.MessageId)
      }

  以用户注册为例产生的事务需求、延迟队列使用
    基本实现
      1、生产者注册成功后发送消息(UserID)
      2、消费者收到消息后，调用邮件服务
      3、调用失败。重新入列（要加个延迟时间，失败次数越多，延迟时间越长）
      4、超过最大重试次数，就不再发邮件了
    
    安装插件
      https://github.com/rabbitmq/rabbitmq-delayed-message-exchange
      这是一个延迟交换机插件。省去我们自己写规则的麻烦
      由于我们使用3.8。因此使用3.8对应的插件
      拷贝到plugins中，容器中对应的目录是/opt/rabbitmq/plugins
      docker cp rabbitmq_delayed_message_exchange-3.8.0.ez rmq:/opt/rabbitmq/plugins

    启用插件(不需要重新启动rabbitmq)
      rabbitmq-plugins enable rabbitmq_delayed_message_exchange

    初始化代码
      关键部分在于
      err:=mq.Channel.ExchangeDeclare(EXCHANGE_USER_DELAY,"x-delayed-message",
        false,false,false,false,
        map[string]interface{}{"x-delayed-type":"direct"}
      )

    发送消息时加入一个头
      x-delay:3000 单位毫秒

    记录消费者调用失败次数
      建表 一旦调用邮件服务失败，进入此表的记录 
        表名:user_notify 
        user_id : 用户ID
        notifynum : 提醒失败次数 默认值1
        isdone:是否结束失败  默认值0
        updatetime: 更新时间
        
    mysql库
      扩展库: go get github.com/jmoiron/sqlx
      驱动: go get github.com/go-sql-driver/mysql

    逼格写法 (超过5次不再调用)
      insert into user_notify(user_id,updatetime)
        values(1234,now()) ON DUPLICATE KEY UPDATE 
        notifynum=IF(isdone=1,notifynum,notifynum+1),
        isdone=IF(notifynum=5,1,0),
        updatetime=IF(isdone=1,updatetime,now())
    
    基本代码
      delay:=msg.Headers["x-delay"]
      if isfail {
        r:=Helper.SetNotify(userID)
        if r==0{
          log.Printf("%s向userID=%s的用户发送邮件---不再重发\n",c,string(msg.Body))
          msg.Ack(false)
          return
        }
        newDelay:=int(delay.(int32)*2)
        msg.Headers["x-delay"]=newDelay

        err:=myclient.SendDelayMessage(Lib.ROUTER_KEY_USERREG,Lib.EXCHANGE_USER_DELAY, string(msg.Body),newDelay)
        if err!=nil{
          log.Println(err)
        }else {
          fmt.Printf("%s向userID=%s的用户发送邮件---失败，重发，延迟：%d\n", c,string(msg.Body),newDelay)
        }
        msg.Reject(false)
      } else {
        fmt.Printf("%s向userID=%s的用户发送邮件---成功\n",c,string(msg.Body))
        msg.Ack(false)
      }
