package lib

import (
	"log"
	"net/http/httputil"
	"net/url"
	"sync"

	"github.com/gin-gonic/gin"
)

var LocalCache *Bcache
var localCache_Once sync.Once
var local_path string //保存本地KV 的路径
func setLocalPath(path string) {
	local_path = path
}
func initLocalCache() {
	localCache_Once.Do(func() {
		LocalCache = NewBcache(local_path)
	})
}

type CacheRequest struct {
	Key   string `json:"key" binding:"required,min=1"`
	Value string `json:"value" binding:"omitempty,min=1"`
}

func NewCacheRequest() *CacheRequest {
	return &CacheRequest{}
}
func CacheMiddleware() gin.HandlerFunc {
	return func(context *gin.Context) {
		defer func() {
			if e := recover(); e != nil {
				context.JSON(400, gin.H{"message": e})
			}
		}()
		if IsLeader() {
			context.Next()
		} else {
			leader_http := GetLeaderHttp()
			addr, _ := url.Parse(leader_http)
			p := httputil.NewSingleHostReverseProxy(addr)
			p.ServeHTTP(context.Writer, context.Request)
			context.Abort()
		}

	}
}
func Error(err error) {
	if err != nil {
		log.Println(err)
		panic(err)
	}
}

//func CacheServer() *gin.Engine{
//	r:=gin.New()
//	r.Use(CacheMiddleware())
//	r.Handle("POST","/get", func(context *gin.Context) {
//		 req:=NewCacheRequest()
//		 Error(context.BindJSON(req))
//		 if v,err:=LocalCache.GetItem(req.Key);err==nil{
//		 	req.Value=v
//			 context.JSON(200,req)
//		 } else{
//			Error(fmt.Errorf("find no cache"))
//		}
//	})
//	r.Handle("POST","/set", func(context *gin.Context) {
//		req:=NewCacheRequest()
//		Error(context.BindJSON(req))
//		req_bytes,_:=json.Marshal(req)
//		future:=RaftNode.Apply(req_bytes,time.Second)
//		if e:=future.Error();e!=nil{
//			Error(e)
//		}else{
//			context.JSON(200,gin.H{"message":"OK"})
//		}
//
//	})
//	return r
//}
