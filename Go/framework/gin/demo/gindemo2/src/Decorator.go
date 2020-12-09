package src

import (
	"fmt"
	"github.com/gin-gonic/gin"
	"github.com/gomodule/redigo/redis"
	"github.com/pquerna/ffjson/ffjson"
	"log"
)

//缓存装饰器
func CacheDecorator(h gin.HandlerFunc,param string,redKeyPattern string,empty interface{}) gin.HandlerFunc {
	return func(context *gin.Context) {
		//redis判断
		 getID:=context.Param(param) //得到ID值
		 redisKey:=fmt.Sprintf(redKeyPattern,getID)
		conn:=RedisDefaultPool.Get()
		defer conn.Close()
		ret,err:=redis.Bytes(conn.Do("get",redisKey))
		if err!=nil { //缓存里没有
			h(context)//执行目标方法
			dbResult,exists:=context.Get("dbResult")
			if !exists{
				dbResult=empty
			}
			retData,_:=ffjson.Marshal(dbResult)
		    conn.Do("setex",redisKey,20,retData)
			context.JSON(200,dbResult)
			log.Println("从数据库读取")

		}else{//缓存有 ，直接抛出
			 log.Println("从 redis读取")
			 ffjson.Unmarshal(ret,&empty)
			context.JSON(200,empty)

		}

	}
}