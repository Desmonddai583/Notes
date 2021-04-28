package main

import (
	"goauth/utils"
	"log"
	"net/http"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/go-oauth2/mysql/v4"
	"github.com/go-oauth2/oauth2/v4/manage"
	"github.com/go-oauth2/oauth2/v4/models"
	"github.com/go-oauth2/oauth2/v4/server"
	"github.com/go-oauth2/oauth2/v4/store"
)

var srv *server.Server

func main() {

	manager := manage.NewDefaultManager()
	//manager.MapAccessGenerate(generates.NewJWTAccessGenerate("", []byte("00000000"), jwt.SigningMethodHS512))
	mysqlStore := mysql.NewDefaultStore(
		mysql.NewConfig("root:123123@tcp(127.0.0.1:3307)/gin?charset=utf8"),
	)
	// manager.MustTokenStorage(store.NewMemoryTokenStore())
	manager.MapTokenStorage(mysqlStore)
	clientStore := store.NewClientStore()
	err := clientStore.Set("mainweb", &models.Client{
		ID:     "mainweb",
		Secret: "123",
		Domain: "http://me.com",
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
			log.Println(err.Error())
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
	//根据token获取 UserId 和 剩余过期时间
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

	//注销的过程，同时删除session 和 token
	r.GET("/logout", func(context *gin.Context) {
		token, err := srv.Manager.LoadAccessToken(context, context.Query("access_token"))
		if err != nil {
			panic(err.Error())
			return
		}
		utils.DeleteUserSession(context)
		err = manager.RemoveAccessToken(context, token.GetAccess())
		if err != nil {
			panic(err.Error())
			return
		}
		context.Redirect(301, context.Query("redirect_uri"))

	})

	//加载模板
	r.LoadHTMLGlob("public/*.html")
	r.Run(":8081")

}
func userAuthorizeHandler(w http.ResponseWriter, r *http.Request) (userID string, err error) {
	if userID = utils.GetUserSession(r); userID == "" {
		w.Header().Set("Location", "/login?"+r.URL.RawQuery)
		w.WriteHeader(302)
	}
	return
}
