package main

import (
	"fmt"
	"io/ioutil"
	"log"
	"time"

	"github.com/dgrijalva/jwt-go"
)

type UserClaim struct {
	Uname string `json:"username"`
	jwt.StandardClaims
}

func main() {
	//priKey:=[]byte("123abc")

	priKeyBytes, err := ioutil.ReadFile("./pem/private.pem")
	if err != nil {
		log.Fatal("私钥文件读取失败")
	}
	priKey, err := jwt.ParseRSAPrivateKeyFromPEM(priKeyBytes)
	if err != nil {
		log.Fatal("私钥文件不正确")
	}

	pubKeyBytes, err := ioutil.ReadFile("./pem/public.pem")
	if err != nil {
		log.Fatal("公钥文件读取失败")
	}
	pubKey, err := jwt.ParseRSAPublicKeyFromPEM(pubKeyBytes)
	if err != nil {
		log.Fatal("公钥文件不正确")
	}

	user := UserClaim{Uname: "shenyi"}
	user.ExpiresAt = time.Now().Add(time.Second * 5).Unix()
	token_obj := jwt.NewWithClaims(jwt.SigningMethodRS256, user)
	token, _ := token_obj.SignedString(priKey)

	fmt.Println(token)

	i := 0
	for {
		uc := UserClaim{}
		getToken, err := jwt.ParseWithClaims(token, &uc, func(token *jwt.Token) (i interface{}, e error) {
			return pubKey, nil
		})
		if getToken != nil && getToken.Valid {
			fmt.Println(getToken.Claims.(*UserClaim).Uname)
		} else if ve, ok := err.(*jwt.ValidationError); ok {
			if ve.Errors&jwt.ValidationErrorMalformed != 0 {
				fmt.Println("错误的token")
			} else if ve.Errors&(jwt.ValidationErrorExpired|jwt.ValidationErrorNotValidYet) != 0 {

				fmt.Println("token过期或未启用")
			} else {
				fmt.Println("Couldn't handle this token:", err)
			}
		} else {
			fmt.Println("无法解析此token", err)
		}

		i++
		fmt.Println(i)
		time.Sleep(time.Second * 1)
	}

}
