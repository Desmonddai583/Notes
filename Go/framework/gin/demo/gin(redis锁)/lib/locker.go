package lib

import (
	"context"
	"fmt"
	"log"
	"time"

	"github.com/go-redis/redis/v8"
)

type Locker struct {
	key        string
	expire     time.Duration
	unlock     bool
	incrScript *redis.Script
}

const incrLua = `
if redis.call('get', KEYS[1]) == ARGV[1] then
  return redis.call('expire', KEYS[1],ARGV[2]) 				
 else
   return '0' 					
end`

func NewLocker(key string) *Locker {
	//默认30秒过期时间
	return &Locker{key: key, expire: time.Second * 30, incrScript: redis.NewScript(incrLua)} //默认30秒
}

//有过期时间
func NewLockerWithTTL(key string, expire time.Duration) *Locker {
	if expire.Seconds() <= 0 {
		panic("error expire")
	}
	return &Locker{key: key, expire: expire, incrScript: redis.NewScript(incrLua)}
}
func (this *Locker) Lock() *Locker {
	boolcmd := redisClient.SetNX(context.Background(), this.key, "1", this.expire)
	if ok, err := boolcmd.Result(); err != nil || !ok {
		panic(fmt.Sprintf("lock error with key:%s", this.key))
	}
	this.expandLockTime()
	return this
}
func (this *Locker) expandLockTime() {
	sleepTime := this.expire.Seconds() * 2 / 3
	go func() {
		for {
			time.Sleep(time.Second * time.Duration(sleepTime))
			if this.unlock {
				break
			}
			this.resetExpire()
		}
	}()
}

//重新设置过期时间
func (this *Locker) resetExpire() {
	cmd := this.incrScript.Run(context.Background(), redisClient, []string{this.key}, 1, this.expire.Seconds())
	v, err := cmd.Result()
	log.Printf("key=%s ,续期结果:%v,%v\n", this.key, err, v)
}

func (this *Locker) Unlock() {
	this.unlock = true
	redisClient.Del(context.Background(), this.key)
}
