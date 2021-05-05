redis第三方库
  go get github.com/go-redis/redis/v8
  文档：https://github.com/go-redis/redis/  

基本原理 
  setnx命令
    指定的 key 不存在时，为 key 设置指定的值
    譬如：SETNX KEY_NAME VALUE
    设置成功，返回 1 。 设置失败，返回 0 
  通过这个命令可以实现锁的效果

续期
  由于请求处理时间可能大于锁过期时间,所以需要有续期的能力
  func(this *Locker) expandLockTime(){
    go func() {
      for{
        this.increExpire()
        time.Sleep(time.Second*1)
      }
    }()
  }
  func(this *Locker) increExpire(){
      cmd:=redisClient.Expire(context.Background(),this.key,this.expire)
      fmt.Println(cmd)
  }

  隔多久续期一次
    比较推荐的做法是 sleepTime:= this.expire.Seconds()* 2 / 3;

    func(this *Locker) increExpire(){	 
    lua := `if redis.call('get', KEYS[1]) == ARGV[1] then 				   return redis.call('expire', KEYS[1],ARGV[2]) 				
      else return '0' 					
    end`       
    scrip:=redis.NewScript(lua)      
    cmd:=scrip.Run(context.Background(),       	redisClient,[]string{this.key},1,this.expire.Seconds())         v,err:=cmd.Result()		  
    log.Printf("key=%s ,续期结果:%v,%v\n",this.key,err,v)
    }

多任务操作加锁
  go get github.com/robfig/cron/v3
