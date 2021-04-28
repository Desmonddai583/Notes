package main

import (
	"fmt"
	"goauth/utils"

	"github.com/gin-gonic/gin"
	"golang.org/x/oauth2"
)

const (
	authServerURL = "http://oauth.jtthink.com"
)

var (
	jtthinkOAuth = oauth2.Config{
		ClientID:     "clienta",
		ClientSecret: "123",
		Scopes:       []string{"all"},
		RedirectURL:  "http://localhost:8080/jtthink/getcode",
		Endpoint: oauth2.Endpoint{
			AuthURL:  authServerURL + "/auth",  //获取授权码地址
			TokenURL: authServerURL + "/token", //获取token地址
		},
	}
)

func main() {

	utils.InitDB()
	r := gin.Default()
	r.Use(utils.ErrorHandler())
	r.LoadHTMLGlob("public/*")
	loginUrl := jtthinkOAuth.AuthCodeURL("myclient")

	r.GET("/", func(c *gin.Context) {
		c.HTML(200, "a-index.html", map[string]string{
			"loginUrl": loginUrl,
		})
	})
	//注册用户
	r.Any("/user/reg", func(c *gin.Context) {
		data := map[string]string{
			"error":   "",
			"message": "",
		}
		if c.Request.Method == "POST" {
			userID := "" // 第三方账号ID
			if c.Query("token") != "" {
				passport := utils.GetUserInfo(authServerURL+"/info", c.Query("token"), true)
				userID = passport.UserId
			}
			source := c.Query("source")
			uname, upass, upass2 := c.PostForm("userName"), c.PostForm("userPass"), c.PostForm("userPass2")
			user, err := utils.AddNewUser(uname, upass, upass2, userID, source)
			if err != nil {
				data["error"] = err.Error()
			} else {
				if userID != "" {
					data["message"] = fmt.Sprintf("账号绑定成功,您的用户名是%s,第三方账号是:%s", user.UserName, userID)
				} else {
					data["message"] = fmt.Sprintf("账号创建成功,您的用户名是%s", user.UserName)
				}
			}
		}
		c.HTML(200, "reg.html", data)
	})
	r.GET("/jtthink/getcode", func(c *gin.Context) {
		source := "jtthink"           //来源
		code, _ := c.GetQuery("code") //得到的授权码
		//请求 token
		token, err := jtthinkOAuth.Exchange(c, code)
		if err != nil {
			c.JSON(400, gin.H{"message": err.Error()})
		} else {
			//是通过 用户中心 提交token ，获取 用户中心的用户ID
			passport := utils.GetUserInfo(authServerURL+"/info", token.AccessToken, true)
			user := utils.GetUserName(source, passport.UserId)
			if user == nil {
				//c.String(200,"您需要注册并绑定账号")
				c.Redirect(302, "/user/reg?token="+token.AccessToken+"&source=jtthink")
			} else {
				c.String(200, "您在本站的用户名是:%s", user.UserName)
			}

		}
	})

	r.Run(":8080")
}
