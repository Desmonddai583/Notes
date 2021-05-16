package tests

import (
	"fmt"
	"goraft/src/lib"
	"log"
	"sync"
	"testing"

	"github.com/gomodule/redigo/redis"
)

var cache *lib.Bcache
var cache_once sync.Once

//本地cache
func getCache() *lib.Bcache {
	cache_once.Do(func() {
		cache = lib.NewBcache("../tmp")
	})
	return cache
}

//测试 本地KV
func Benchmark_AddKV(t *testing.B) {
	for i := 0; i < t.N; i++ {
		key := fmt.Sprintf("key%d", i)
		value := key + "value"
		err := getCache().SetItem(key, value)
		if err != nil {
			log.Println("kv error:", err.Error())
		}
	}

}

var rcache redis.Conn
var rcache_once sync.Once

func getRedisCache() redis.Conn {
	rcache_once.Do(func() {
		c, err := redis.Dial("tcp", "127.0.0.1:6379")
		if err != nil {
			fmt.Println("Connect to redis error", err)
			return
		}
		rcache = c
	})
	return rcache
}

// 测试 redis 插入
func Benchmark_AddRedis(t *testing.B) {
	for i := 0; i < t.N; i++ {
		key := fmt.Sprintf("key%d", i)
		value := key + "value"
		_, err := getRedisCache().Do("set", key, value)
		if err != nil {
			log.Println("redis set error", err)
		}
	}
}
