package main

import (
	"goauth/utils"
	"log"
	"net/http"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/go-oauth2/oauth2/v4/manage"
	"github.com/go-oauth2/oauth2/v4/models"
	"github.com/go-oauth2/oauth2/v4/server"
	"github.com/go-oauth2/oauth2/v4/store"
)

var srv *server.Server

func main() {

	manager := manage.NewDefaultManager()
	manager.MustTokenStorage(store.NewMemoryTokenStore())

	clientStore := store.NewClientStore()
	err := clientStore.Set("clienta", &models.Client{
		ID:     "clienta",
		Secret: "123",
		Domain: "http://localhost:8080",
	})
	if err != nil {
		log.Fatal(err)
	}
	manager.MapClientStorage(clientStore)

	srv = server.NewDefaultServer(manager)
	srv.SetUserAuthorizationHandler(userAuthorizeHandler)

	r := gin.New()
	r.Use(utils.ErrorHandler())
	//响应授权码
	r.GET("/auth", func(context *gin.Context) {
		err := srv.HandleAuthorizeRequest(context.Writer, context.Request)
		if err != nil {
			panic(err.Error())
		}
	})
	//根据授权码获取token
	r.POST("/token", func(context *gin.Context) {
		err := srv.HandleTokenRequest(context.Writer, context.Request)
		if err != nil {
			panic(err.Error())
		}
	})

	//如果没有登录 则跳转登录界面
	r.Any("/login", func(c *gin.Context) {
		data := map[string]string{
			"error": "",
		}
		if c.Request.Method == "POST" {
			uname, upass := c.PostForm("userName"), c.PostForm("userPass")
			if uname+upass == "shenyi123" {
				utils.SaveUserSession(c, uname)
				c.Redirect(302, "/auth?"+c.Request.URL.RawQuery)
				return
			} else {
				data["error"] = "用户名密码错误"
			}
		}
		c.HTML(200, "login.html", data)
	})

	r.POST("/info", func(context *gin.Context) {
		token, err := srv.ValidationBearerToken(context.Request)
		if err != nil {
			panic(err.Error())
		}
		ret := gin.H{"user_id": token.GetUserID(),
			"expire": int64(token.GetAccessCreateAt().Add(token.GetAccessExpiresIn()).Sub(time.Now()).Seconds()),
		}
		context.JSON(200, ret)
	})

	//加载模板
	r.LoadHTMLGlob("public/*.html")
	r.Run(":80")

}
func userAuthorizeHandler(w http.ResponseWriter, r *http.Request) (userID string, err error) {
	if userID = utils.GetUserSession(r); userID == "" {
		w.Header().Set("Location", "/login?"+r.URL.RawQuery)
		w.WriteHeader(302)
	}
	return
}
