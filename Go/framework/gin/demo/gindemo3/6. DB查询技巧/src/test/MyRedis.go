package test

import (
	"github.com/gomodule/redigo/redis"
	"time"
)

var RedisDefaultPool *redis.Pool

func NewPool(addr string) *redis.Pool {
	return &redis.Pool{
		Dial: func() (conn redis.Conn, e error) {
			return redis.Dial("tcp", addr)
		},
		MaxIdle:     3,
		IdleTimeout: 240 * time.Second,
	}
}

func InitRedis() {
	RedisDefaultPool = NewPool("127.0.0.1:6379")
}
