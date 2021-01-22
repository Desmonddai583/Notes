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
  
  死信队列手工实现延迟队列
    简单概念
      当消息在一个队列中变成死信(Dead Letter Exchanges)后，它能被重新send到另一个exchange
      变成死信的三种方法
        1. 消息被拒绝(basic.reject/basic.nack)并且requeue=false
        2. 消息TTL过期
        3. 队列达到最大长度
      利用这些特性,可以手工实现一个延迟队列

场景实例
  1. 以用户注册为例产生的事务需求、延迟队列使用
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
        if r==0 {
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

  2. 异构系统转账
    A公司的表
      表名usermoney
      user_name:用户名 主键
      user_money: 余额，默认0

      交易日志表
        1、tid 主键自增
        2、from  从谁那里扣钱 （用户名就是）
        3、to 钱给谁
        4、money 钱多少
        5、status  状态很重要  0 是等待处理(默认值)  1 处理OK  2 交易失败
        6、updatetime  更新时间

    B公司的表
      表名umoney
      uname:用户名 主键
      umoney: 余额，默认0

    A公司转账业务逻辑
      记录日志
        1、从from里面取出用户名
        2、扣款
        3、记录交易日志
        事务保证

        基本代码
          SQL 
            update usermoney set user_money=user_money-:money 
                    where user_name=:from and user_money>=:money
          SQL 2
            insert into translog(`from`,`to`,money,updatetime)
                  values(:from,:to,:money,now()) 

          func TransMoney(tm *TransModel) error{
            tx:=GetDB().MustBeginTx(context.Background(),nil)
            ret,_:= tx.NamedExec("update usermoney set user_money=user_money-:money" +
                " where user_name=:from and user_money>=:money",tm)
              affected,_:=ret.RowsAffected()
              if affected==0 {
                tx.Rollback()
                return fmt.Errorf("钱不够")
              }
            ret,_=tx.NamedExec("insert into translog(`from`,`to`,money,updatetime)" +
              " values(:from,:to,:money,now()) ",tm)

            affected,_=ret.RowsAffected()
            if affected==0 {
              tx.Rollback()
              return fmt.Errorf("转账日志")
            }
            return tx.Commit()
          }
  
      发送消息
        定义交换机
          //交换机	
          EXCHANGE_TRANS="TransExchange" //转账相关交换机
          //路由Key
          ROUTER_KEY_TRANS="trans" //转账相关路由key ,A公司
          //队列名
          QUEUE_TRANS="TransQueueA" //转账相关队列

        RabbitMQ有事务,也可以confirm模式来获取失败的key,但这些其实都有可能会失败
        日志表记录必须要成功
        如果第一步成功的一刹那，突然发生宕机。那么不管是事务还是confirm都有可能获取不到

    定时补偿机制
      不管发送成功与否
      1、写个 “死循环”程序
      2、定时取5秒或自定义秒内 ：status==0 的数据，再发一次消息
      3、设定定时任务。定时清理20秒内（或自定义）status==0的消息，把它改为status=2

      定时任务 第三方库
      go get github.com/robfig/cron/v3@v3.0.0

      取消转账的代码
        const FailSql="update translog set STATUS=2 where TIMESTAMPDIFF(SECOND,updatetime,now())>30 and STATUS<>2"
        func FailTrans(){
          _,err:= Trans.GetDB().Exec(FailSql)
          if err!=nil{
            log.Println(err)
          }
        }
      
      定时器设定
        var MyCron *cron.Cron
        func initCron() error {
          MyCron=cron.New(cron.WithSeconds())
          _,err:=MyCron.AddFunc("0/3 * * * * *", FailTrans)
          return err
        }

      交易失败后还钱
        两个任务
          取消交易
            update translog set STATUS=2 where TIMESTAMPDIFF(SECOND,updatetime,now())>20 and STATUS<>2
          还钱
            首先加个字段: isback
            select tid, `from`,money from translog  where status=2 and isback=0 limit 10
        
        这里面为了防止 数据不一致，都要依赖数据库事务

        统一的事务提交
          func clearTx(tx *sqlx.Tx){
            err:=tx.Commit()
            if err!=nil && err!=sql.ErrTxDone{
              log.Println("tx error:",err)
            }
            islock=false
          }
      
        主要代码
          tx,err:=Trans.GetDB().BeginTxx(context.Background(),nil)
          if err!=nil{
            log.Println("tx error:",err)
            return
          }
          defer clearTx(tx)
          rows,err:=tx.Query(Sql)
          if err!=nil{
            log.Println(err)
            return
          }
          defer rows.Close()

          tms:=[]Trans.TransModel{}
          _=sqlx.StructScan(rows, &tms)
          for _,tm:=range tms{
            _,err=tx.Exec("update usermoney set user_money=user_money+? where user_name=?",tm.Money,tm.From)
            if err!=nil{
              tx.Rollback()
            }
            _,err=tx.Exec("update translog set isback=1 where tid=?",tm.Tid)
            if err!=nil{
              tx.Rollback()
            }
          }
      
      重发MQ消息、B公司记录日志    
        取出交易时间在8秒内，且status=0的数据，进行MQ重发
          1、SQL
            select * from translog where TIMESTAMPDIFF(SECOND,updatetime,now())<=8 and STATUS=0
          2、定时器设置
            每隔2秒处理

        B公司日志表
          和A公司一样。但是不需要IsBack
          tid注意不需要自增 

      B公司确认收钱
        A和B、要约定个回调地址（A是回调地址） http://localhost:8080/callback-----A
        接收POST参数,参数：tid
        SQL update translog set status=1 where tid=? and status=0

        简易过程
          tid:=context.PostForm("tid")
          sql:="update translog set status=1 where tid=? and status=0"
          ret,err:=Trans.GetDB().Exec(sql,tid)
          affCount,err2:=ret.RowsAffected()
          if err!=nil || err2!=nil  || affCount!=1{
            context.String(200,"error")
          }else{
            context.String(200,"success")
          }

        接下来有两种做法
          第一种
            B消费者 消费到记录后 执行两个过程(使用事务)
              1） 插记录
              2） 回调接口
              commit
            两步必须都成功。否则回滚数据库。然后时候再通过定时任务把钱更新到B里面的用户 
          第二种
            B消费者 消费到记录后 执行3个过程(使用事务)
              1） 插记录
              2） 把钱更新给用户
              3） 回调接口
            3步必须都成功。否则回滚数据库

        回调接口代码
          func callBack(tid int ) error{
            rsp,err:=http.Post("http://localhost:8080/callback",
              "application/x-www-form-urlencoded",strings.NewReader(fmt.Sprintf("tid=%d",tid)))
            if err!=nil{
              log.Println(err)
              return err 
            }
            defer rsp.Body.Close()
            b,err:=ioutil.ReadAll(rsp.Body)
            if err!=nil{
              log.Println(err)
              return err 
            }
            if string(b)=="success"{
              return nil 
            }else {
              return fmt.Errorf("error")
            }
          }

  3. 异步下单
    订单主表
      order_id: 主键自增
      order_no: 订单号
      order_state:状态。默认是1
      order_time：下单时间
      order_user: 订单用户ID

    订单号生成
      1、UUID
        https://github.com/satori/go.uuid

      2、雪花算法
        https://github.com/bwmarrin/snowflake

        node, err := snowflake.NewNode(1)
        if err != nil {
          fmt.Println(err)
          return
        }
        id := node.Generate()
        fmt.Println(id.String())

      3、年月日+随机数+userid

    设置MQ
      交换机：Exchange_Order
      绑定Key:  Key_Order
      队列名: Queue_Order

      消息内容
        {
          “userid”:xxx,   //实际开发应该是token
          “orderno”:xxx, (其实不用填)
          “ordertime”:xxxx  (其实不用填)
        }