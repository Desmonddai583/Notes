package utils

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/gorilla/sessions"
)

var sessionStore = sessions.NewCookieStore([]byte("123456"))

func init() {
	sessionStore.Options.Domain = "oauth.me.com"
	sessionStore.Options.Path = "/"
	sessionStore.Options.MaxAge = 0 //关掉浏览器就清掉session
}

// oauth2 服务端使用： 删除当前session
func DeleteUserSession(c *gin.Context) {
	s, err := sessionStore.Get(c.Request, "LoginUser")
	if err == nil {
		s.Options.MaxAge = -1
		err = s.Save(c.Request, c.Writer) //save 保存
		if err != nil {
			panic(err.Error())
		}
	} else {
		panic(err.Error())
	}
}

// oauth2 服务端使用： 保存当前用户登录的ID
func SaveUserSession(c *gin.Context, userID string) {
	s, err := sessionStore.Get(c.Request, "LoginUser")
	if err != nil {
		panic(err.Error())
	}
	s.Values["userID"] = userID
	err = s.Save(c.Request, c.Writer) //save 保存
	if err != nil {
		panic(err.Error())
	}
}

// oauth2 服务端使用： 获取当前用户登录的ID
func GetUserSession(r *http.Request) string {
	if s, err := sessionStore.Get(r, "LoginUser"); err == nil {

		if s.Values["userID"] != nil {
			return s.Values["userID"].(string)
		}
	}
	return ""
}
