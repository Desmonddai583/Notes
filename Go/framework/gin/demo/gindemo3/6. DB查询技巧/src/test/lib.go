package test

import (
	"encoding/json"
	"fmt"
	"github.com/gin-gonic/gin"
	"github.com/gomodule/redigo/redis"
	"log"
)

func Auth(conn redis.Conn) redis.Conn {
	//conn.Do("AUTH", "123456")
	return conn
}

//缓存装饰器
func CacheDecorator(h gin.HandlerFunc, param string, redisKeyPattern string, empty interface{}) gin.HandlerFunc {
	return func(context *gin.Context) {
		param = context.Param(param)
		log.Println(param,111)
		conn := RedisDefaultPool.Get()
		defer conn.Close()
		redisKey := fmt.Sprintf(redisKeyPattern, param)
		ret, err := redis.Bytes(conn.Do("get", redisKey)) //这样套一层才返回bytes
		if err != nil {
			log.Print("从数据库读取")
			h(context)
			dbResult, exists := context.Get("dbResult")
			if !exists {
				context.JSON(200, empty)
				return
			} else {
				retData, _ := json.Marshal(dbResult)
				conn.Do("setex", redisKey, 20, retData)
				context.JSON(200, dbResult)
			}
		} else {
			_ = json.Unmarshal(ret, &empty)
			log.Print("从缓存读取")
			context.JSON(200, empty)
		}

	}
}
