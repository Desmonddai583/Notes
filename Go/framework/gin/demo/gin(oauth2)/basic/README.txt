OAuth2（开放授权）
  是一个开放标准，允许用户授权第三方移动应用访问他们存储在另外的服务提供者上的信息，而不需要将用户名和密码提供给第三方移动应用或分享他们数据的所有内容，
  OAuth2.0是OAuth协议的延续版本，但不向后兼容OAuth 1.0即完全废止了OAuth1.0 
  最常见的场景就是 QQ登录、微信登录、github登录等

四种模式
  授权码模式 (Authorization Code)  
  简化模式 (Implicit)
  密码模式 (Resource Owner Password Credentials)
  客户端模式 (Client Credentials)

go get -u github.com/go-oauth2/oauth2/v4/
go get github.com/gin-gonic/gin

客户端请求授权码
  服务端代码
    创建管理对象，token默认存在内存里(之后肯定需要存到mysql或redis中)
    manager := manage.NewDefaultManager()
	  manager.MustTokenStorage(store.NewMemoryTokenStore())
  客户端与服务端关联
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
  创建http服务
    srv = server.NewDefaultServer(manager)
	  srv.SetUserAuthorizationHandler(userAuthorizeHandler)
	  r := gin.New()
    r.GET("/auth", func(context *gin.Context) {
      err := srv.HandleAuthorizeRequest(context.Writer, context.Request)
      if err != nil {
        panic(err.Error())
      }
    })
    r.GET("/login", func(c *gin.Context) {
      c.HTML(200, "login.html", nil)
    })
    r.LoadHTMLGlob("public/*.html")
	  r.Run(":80")
  关键部分
    func userAuthorizeHandler(w http.ResponseWriter, r *http.Request) (userID string, err error) {
      if userID = utils.GetUserSession(r); userID == "" {
        w.Header().Set("Location", "/login?"+r.URL.RawQuery)
        w.WriteHeader(302)
      }
      return
    }
  使用第三方的session库
    go get github.com/gorilla/sessions

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

客户端使用授权码请求token
  oauth2的客户端库
    go get golang.org/x/oauth2
  
  官方代码
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
          AuthURL:  authServerURL + "/auth",  //获取授权码 地址
          TokenURL: authServerURL + "/token", //获取token地址
        },
      }
    )
  
  后续请求
    token, err := jtthinkOAuth.Exchange(c, code)
		if err != nil {
			c.JSON(400, gin.H{"message": err.Error()})
		} else {
			c.JSON(200, token)
		}
  
  服务端代码
    r.POST("/token", func(context *gin.Context) {
      err := srv.HandleTokenRequest(context.Writer, context.Request)
      if err != nil {
        panic(err.Error())
      }
    })

客户端使用token获取用户信息
  服务端代码
    r.POST("/info", func(context *gin.Context) {
      token,err:=srv.ValidationBearerToken(context.Request)
      if err!=nil{
        panic(err.Error())
      }
      info:=gin.H{"user_id":token.GetUserID(),
        "expire":int64(token.GetAccessCreateAt().Add(token.GetAccessExpiresIn()).Sub(time.Now()).Seconds())}
      context.JSON(200,info)
    })

  获取token的方式
    OAuth 2.0 定义了获取 Access Token 的方法
    第一种 :放在头里
      GET /info  HTTP/1.1
      Host: server.example.com
      Authorization: Bearer xxxxxooo

    第二种：放到Form参数里
      Content-Type: application/x-www-form-urlencoded
      access_token=xxoxooxoo

  客户端代码
    r.GET("/info", func(context *gin.Context) {
      token:=context.Query("token")
      str:=utils.GetUserInfo(authServerURL+"/info",token,true)
      context.Writer.Header().Set("Content-type","application/json")
      context.String(200,str)
    })

oAuth2下用户表的设计
  几个规则  
    对于 自主注册的用户
      source_id是0 ， source_userid 也是空的

    对于oauth2登录的用户，取到token后，请求并获取userid
      1、如果该用户ID 在 source_userid 中找到，则自动登录
      2、否则要求用户注册，并绑定该用户ID

  go get -u gorm.io/gorm
  go get gorm.io/driver/mysql