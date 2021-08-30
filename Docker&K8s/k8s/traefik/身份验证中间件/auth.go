package main

import (
	"fmt"
	"github.com/dgrijalva/jwt-go"
	"github.com/gin-gonic/gin"
	"log"
	"time"
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
func main()  {
	r:=gin.New()
	r.Any("/auth", func(context *gin.Context) {
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
		var userName,userPass=c.DefaultQuery("userid",""),c.DefaultQuery("secret","")
		if pass,ok:=allowUsers[userName];ok && userPass==pass{
			c.JSON(200,gin.H{"token":genToken(userName)})
		}else{
			c.JSON(400,gin.H{"message":"error uid and secret"})
		}
	})
	r.Run(":80")
}
