package main

import "github.com/gin-gonic/gin"

func main()  {
	 r:=gin.New()
	 r.Use(func(context *gin.Context) {
		 if getUser:=context.GetHeader("X-Auth-User");getUser==""{
		 	context.AbortWithStatusJSON(401,gin.H{"message":"error auth"})
		 }else{
		 	context.Set("CurrentUser",getUser)
		 	context.Next()
		 }
	 })
	 r.GET("/depts", func(context *gin.Context) {
	 	  getUser,exists:=context.Get("CurrentUser")
	 	   if !exists{
	 	   	 getUser="unkown"
		   }
		 context.JSON(200,gin.H{"message":"depts list","currentUser":getUser})
	 })
	 r.Run(":80")
}
