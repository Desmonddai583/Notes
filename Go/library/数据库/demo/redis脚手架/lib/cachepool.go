package lib

import (
	"sync"
	"time"

	"github.com/shenyisyn/goft-redis/gedis"
)

var NewsCachePool *sync.Pool

func init() {
	NewsCachePool = &sync.Pool{
		New: func() interface{} {
			return gedis.NewSimpleCache(gedis.NewStringOperation(), time.Second*150,
				gedis.Serilizer_JSON,
				gedis.NewCrossPolicy("^news\\d{1,5}$", time.Second*30)) // 指定序列化 是JSON
		},
	}
}
func NewsCache() *gedis.SimpleCache {
	return NewsCachePool.Get().(*gedis.SimpleCache)
}
func ReleaseNewsCache(cache *gedis.SimpleCache) {
	NewsCachePool.Put(cache)
}
