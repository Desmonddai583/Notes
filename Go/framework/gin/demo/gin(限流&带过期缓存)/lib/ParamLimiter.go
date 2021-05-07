package lib

import "github.com/gin-gonic/gin"

// /abc?name=xxx   name 就是 key 参数
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