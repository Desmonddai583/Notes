令牌桶算法的原理
  系统会以一个恒定的速度往桶里放入令牌，询问“能不能干之前”，则需要先从桶里获取一个令牌，当桶里没有令牌可取时，则拒绝服务

构建一个桶
  最基本的要素是
    1、桶的容量
    2、当前有多少个令牌
    3、一个互斥锁

  type Bucket struct {   
    cap int   
    token int   
    lock sync.Mutex
  }
  func NewBucket(cap int, token int) *Bucket {   
    if token>cap{      
      token=cap   
    }   
    return &Bucket{cap: cap, token: token}
  }
  func(this *Bucket) IsAccept() bool{   
    this.lock.Lock()   
    defer this.lock.Unlock()   
    if this.token>0{      
      this.token--      
      return true   
    }   
    return false
  }

编写限流装饰器装饰gin处理函数
  func Limiter(cap int) func(handler gin.HandlerFunc) gin.HandlerFunc{      
    limiter:=NewBucket(cap)      
    return func(handler gin.HandlerFunc) gin.HandlerFunc {         
      return func(c *gin.Context) {            
        if limiter.IsAccept(){               
          handler(c)            
        }else{               
          c.AbortWithStatusJSON(429,gin.H{"message":"too many requests"})            
        }         
      }      
    }
  }

简单扩展之基于参数限流
  func ParamLimiter(cap int64,rate int64,key string ) func(handler gin.HandlerFunc) gin.HandlerFunc{
    limiter:=NewBucket(cap,rate)
    return func(handler gin.HandlerFunc) gin.HandlerFunc {
      return func(context *gin.Context) {
        if context.Query(key)!=""{
            if limiter.IsAccept(){
              handler(context)
          }else{
            context.AbortWithStatusJSON(429,gin.H{"message":"too many requests-param"})
          }
        }else{
            handler(context)
        }
      }
    }
  }

LRU算法（Least Recently Used的缩写，即最近最少使用）
  在container/list 包中 有个自带的双向链表
  它的每个数据中都有两个指针，分别指向直接后继和直接前驱。所以，从双向链表中的任意一个结点开始，都可以很方便地访问它的前驱结点和后继结点。

  ll:=&list.List{}
  e1:=ll.PushFront("e1")//在链表的最前端插入新元素
  e2:=ll.PushFront("e2")
  ll.InsertAfter("e3",e2)
  fmt.Println(e1.Value)
  fmt.Println(e2.Next().Value)

  对缓存对象进行封装
    type cacheData struct {   
      key string   
      value interface{}   
      expireAt time.Time
    }

  删除最后一个
    func(this *GCache) RemoveOldest(){
      this.lock.Lock()
      defer this.lock.Unlock()
      back:=this.elist.Back()
      if back==nil{
        return
      }
      this.removeItem(back)
    }
  
  设置缓存
    func(this *GCache) Set(key string ,newv interface{}){
      this.lock.Lock()
      defer this.lock.Unlock()
      newCache:=newCacheData(key,newv)
      if v,ok:=this.edata[key];ok{
        v.Value=newCache
        this.elist.MoveToFront(v)
      }else{
        this.edata[key]=this.elist.PushFront(newCache)
      }
    }