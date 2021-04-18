package gedis

import (
	"regexp"
	"time"
)

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
