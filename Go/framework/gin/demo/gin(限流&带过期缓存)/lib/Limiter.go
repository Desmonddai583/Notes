package lib

import "github.com/gin-gonic/gin"

//限流装饰器
func Limiter(cap int64) func(handler gin.HandlerFunc) gin.HandlerFunc{
	limiter:=NewBucket(cap,1)
	return func(handler gin.HandlerFunc) gin.HandlerFunc {
		return func(c *gin.Context) {
			if limiter.IsAccept(){
				handler(c)
			}else{
				c.AbortWithStatusJSON(429,gin.H{"message":"too many requests"})
			}
		}
	}
}
