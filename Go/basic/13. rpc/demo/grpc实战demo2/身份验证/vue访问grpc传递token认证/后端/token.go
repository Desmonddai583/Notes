package main

import (
	"fmt"
	"log"
	"net/http"
	"time"
	"github.com/dgrijalva/jwt-go"
	"github.com/gin-gonic/gin"
)

var allowUsers=map[string]string{"shenyi":"123","lisi":"234"}
type Claims struct {
	UserID string `json:"userid"`
	jwt.StandardClaims
}
var signKey = []byte("234567") //所谓的加密秘钥
//生成token 。代码都是官方抄的
func genToken(userID string ) string {
	claims := &Claims{
		UserID: userID,
		StandardClaims: jwt.StandardClaims{
			ExpiresAt: time.Now().Add(25 * time.Second).Unix(),  //默认25秒过期时间
		},
	}
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	token_string,err:=token.SignedString(signKey)
	if err!=nil{
		log.Println(err)
		return ""
	}
	return token_string
}
// 反解token
func parseToken(token string ) (*Claims, error){
	claims:=&Claims{}
	_,err:=jwt.ParseWithClaims(token,claims, func(token *jwt.Token) (i interface{}, e error) {
		return signKey,nil
	})
	if err!=nil{
		return nil,err
	}
	return claims,nil
}
func cross() gin.HandlerFunc {
	return func(c *gin.Context) {
		method := c.Request.Method
		if method != "" {
			c.Header("Access-Control-Allow-Origin", "*") // 可将将 * 替换为指定的域名
			c.Header("Access-Control-Allow-Methods", "POST, GET, OPTIONS, PUT, DELETE, UPDATE")
			c.Header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept, Authorization,X-Token")
			c.Header("Access-Control-Expose-Headers", "Content-Length, Access-Control-Allow-Origin, Access-Control-Allow-Headers, Cache-Control, Content-Language, Content-Type")
			c.Header("Access-Control-Allow-Credentials", "true")
		}
		if method == "OPTIONS" {
			c.AbortWithStatus(http.StatusNoContent)
		}
		c.Next()

	}
}
func main()  {
	r:=gin.New()
	r.Use(cross())
	r.POST("/auth", func(context *gin.Context) {
		fmt.Println(context.Request.Header)
		if token:=context.GetHeader("X-Forwarded-Token");token!=""{
			claim,err:=parseToken(token)
			if err!=nil{
				context.JSON(401,gin.H{"message":"error token"})
			}else{
				context.Header("X-Auth-User",claim.UserID) //响应头
				context.JSON(200,gin.H{"message":"ok"+claim.UserID})
			}
		}else{
			context.JSON(401,gin.H{"message":"access denied"})
		}
	})
	r.GET("/access_token", func(c *gin.Context) {
		// traefik
		var userName,userPass=c.DefaultQuery("userid",""),c.DefaultQuery("secret","")
		if pass,ok:=allowUsers[userName];ok && userPass==pass{
			c.JSON(200,gin.H{"code":20000,"token":genToken(userName)})
		}else{
			c.JSON(400,gin.H{"code":40000,"message":"error uid and secret"})
		}
	})
	r.Run(":9090")
}

