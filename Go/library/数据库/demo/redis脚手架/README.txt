安装底层redis库
  go get github.com/go-redis/redis/v8

初始化代码
  redisClient= redis.NewClient(&redis.Options{
    Network:  "tcp",
    Addr:     "127.0.0.1:63739",
    Password: "",                     //密码
    DB:       0,              // redis数据库

    //连接池容量及闲置连接数量
    PoolSize:     15, // 连接池数量
    MinIdleConns: 10, //好比最小连接数
    //超时
    DialTimeout:  5 * time.Second, //连接建立超时时间
    ReadTimeout:  3 * time.Second, //读超时，默认3秒， -1表示取消读超时
    WriteTimeout: 3 * time.Second, //写超时，默认等于读超时
    PoolTimeout:  4 * time.Second, //当所有连接都处在繁忙状态时，客户端等待可用连接的最大等待时长，默认为读超时+1秒。

    //闲置连接检查包括IdleTimeout，MaxConnAge
    IdleCheckFrequency: 60 * time.Second, //闲置连接检查的周期，默认为1分钟，-1表示不做周期性检查，只在客户端获取连接时对闲置连接进行处理。
    IdleTimeout:        5 * time.Minute,  //闲置超时
    MaxConnAge:         0 * time.Second,  //连接存活时长，从创建开始计时，超过指定时长则关闭连接，默认为0，即不关闭存活时长较长的连接

    //命令执行失败时的重试策略
    MaxRetries:      0,                      // 命令执行失败时，最多重试多少次，默认为0即不重试
    MinRetryBackoff: 8 * time.Millisecond,   //每次计算重试间隔时间的下限，默认8毫秒，-1表示取消间隔
    MaxRetryBackoff: 512 * time.Millisecond, //每次计算重试间隔时间的上限，默认512毫秒，-1表示取消间隔

  })
  pong, err := redisClient.Ping(context.Background()).Result()
  if err!=nil{
    log.Fatal(fmt.Errorf("connect error:%s",err))
  }
  log.Println(pong)

Redis常用类型
  string（字符串），hash（哈希），list（列表），set（集合）及zset(sorted set：有序集合)

Set命令封装
  从 Redis 2.6.12 版本开始， SET 命令的行为可以通过一系列参数来修改：
    EX second ：设置键的过期时间为 second 秒。 SET key value EX second 效果等同于 SETEX key second value 。
    PX millisecond ：设置键的过期时间为 millisecond 毫秒。 SET key value PX millisecond 效果等同于 PSETEX key millisecond value 。
    NX ：只在键不存在时，才对键进行设置操作。 SET key value NX 效果等同于 SETNX key value 。
    XX ：只在键已经存在时，才对键进行设置操作。
  因为 SET 命令可以通过参数来实现和 SETNX 、 SETEX 和 PSETEX 三个命令的效果，所以将来的 Redis 版本可能会废弃并最终移除 SETNX 、 SETEX 和 PSETEX 这三个命令。
 
  初步代码
    type  OperationAttr struct {
      Name string
      Attr interface{}
    }
    type  OperationAttrs []*OperationAttr
    func WithExpire(t time.Duration)   *OperationAttr  {
        return &OperationAttr{Name:"Expire",Attr:t}
    }
    func(this OperationAttrs) Find(name string ) interface{}{
      for _,op:=range this{
        if op.Name==name{
          return  op.Attr
        }
      }
      return nil
    }

缓存组件
  基本结构
    type DBGetterFunc func() string
    type SimpleCache struct {
      Operation *StringOperation
      Expire time.Duration
      DBGetter DBGetterFunc
    }

  结合Gorm进行数据读取
    go get -u gorm.io/gorm
    go get -u gorm.io/driver/mysql

    var Gorm *gorm.DB
    func init(){
      Gorm=gormDB()
    }
    func gormDB() *gorm.DB {
      dsn:="root:123123@tcp(localhost:3307)/test?charset=utf8mb4&parseTime=True&loc=Local"
      db, err := gorm.Open(mysql.Open(dsn),&gorm.Config{})
      if err != nil {
        log.Fatal(err)
      }
      mysqlDB,err:=db.DB()
      if err != nil {
        log.Fatal(err)
      }
      mysqlDB.SetMaxIdleConns(5)
      mysqlDB.SetMaxOpenConns(10)
      return db
    }

  增加序列化方式选项(JSON)
    type SimpleCache struct {
      Operation *StringOperation  //操作类
      Expire time.Duration  // 过期时间
      DBGetter  DBGetterFunc // 一旦缓存中没有  DB获取的方法
      Serilizer string  // 序列化方式
    }
    const (
      Serilizer_JSON="json"
    )

缓存穿透封装
  基本防范
    1、对唯一标识 做 基本限制。譬如 id 必须在某些范围内
    2、一旦数据库没有，则也在redis中置入空值，需要设置过期时间(这个过期时间和正常的Key一般是不一样的)
    3、其他手段 ，如用户必须登录、IP限流等 ---暂时不表

  策略文件
    type CachePolicy interface {
      Before(key string)
      IfNil(key string, v interface{})
      SetOperation(opt *StringOperation)
    }

    //缓存穿透 策略
    type CrossPolicy struct {
      KeyRegx string //检查key的正则
      Expire  time.Duration
      opt     *StringOperation
    }

    func NewCrossPolicy(keyRegx string, expire time.Duration) *CrossPolicy {
      return &CrossPolicy{KeyRegx: keyRegx, Expire: expire}
    }

    func (this *CrossPolicy) Before(key string) {
      if !regexp.MustCompile(this.KeyRegx).MatchString(key) {
        panic("error cache key")
      }
    }
    func (this *CrossPolicy) IfNil(key string, v interface{}) {
      this.opt.Set(key, v, WithExpire(this.Expire)).Unwrap()

    }
    func (this *CrossPolicy) SetOperation(opt *StringOperation) {
      this.opt = opt
    }

  响应方式
    newsMode:=lib.NewNewsModel()
	  newsCache.GetCacheForObject("news"+newsID,newsMode)
	  context.JSON(200,newsMode)
