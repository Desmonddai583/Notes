hosts文件加入
  127.0.0.1    api.me.com  (api)
  127.0.0.1    me.com  (前端网站)
  127.0.0.1    oauth.me.com (用户中心)

nginx跨域配置 
  add_header Access-Control-Allow-Credentials true ;
  add_header Access-Control-Allow-Origin * always;
  add_header Access-Control-Allow-Methods 'GET, POST, PUT, DELETE, OPTIONS' always;
  add_header Access-Control-Allow-Headers 'DNT,X-Mx-ReqToken,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Authorization' always;
  if ($request_method = 'OPTIONS') {
      return 204;
  }

获取token
  构建请求参数
    const postData = {
      code:this.code,
      scope:"all",
      redirect_uri:config.redirect_uri,
      grant_type: config.grant_type
    }
  
  具体请求
    axios.post(config.accessTokenUri,Qs.stringify(postData),{
      headers:{"Content-type":"application/x-www-form-urlencoded"},
      auth: {
        username: config.client_id,
        password: config.client_secret
      }
    })
    .then((rsp)=>{
        
    })

请求数据获取用户信息
  通过授权码访问，获取到了token 和 refresh_token
  在前端常见的做法是：
    保存到localstorage中 ,下次每次请求带token访问
    const {access_token, refresh_token} =rsp.data
    localStorage.setItem("access_token",access_token)
    localStorage.setItem("refresh_token",refresh_token)

  构建api.me.com
    假设 api.me.com有1个 api  
      GET /depts 代表是获取部门列表
    这 API 需要token ，否则禁止访问 . 为了演示简单，假设我们的token是GET参数的方式传递。譬如/depts?token=xxxxxx

前端请求判断token
  前端保存部分
    const {access_token, refresh_token} =rsp.data
    localStorage.setItem("login_user",{access_token,refresh_token})
    self.location="/"

  路由守卫
    const nologin=["/login","/","/auth_code"];
    router.beforeEach((to, from, next) => {
      if (nologin.indexOf(to.path)>-1) {
          next();
      } else {
          let token = localStorage.getItem('login_user');
          if (token === null || token === '') {
              next('/login');
          } else {
              next();
          }
      }
    });

  axios拦截
    axios.interceptors.request.use(config=>{
      let getToken = localStorage.getItem('login_user');
      if(getToken!=null && getToken!==""){
          let {access_token}=JSON.parse(getToken)
          if(config["params"])
              config.params["token"]=access_token;
          else
              config["params"]={token:access_token}
      }
      return config;
    })

注销流程
  1、前端请求 注销API 。 用户中心清掉session,并删除token
  2、http请求OK的话，前端清掉localstorage

刷新token
  得到token去用户中心判断用户合法性时其实有个细节
  首先 userid 必须有值，空值就是 无效用户
  同时，还要判断Expire。如果快过期了，我们需要续期

  不续期会出现 用户前一次点击有数据，下一秒突然失效了会导致用户体验很差,因此我们续期

  改造- 前端部分
    我们在登录时，把过期时间加入到localstorage中
    代码在/autocode.vue 中
    判断是否 达到“你认为过期”的时间,如果是执行续期  
    var now = new Date();
    const {access_token, refresh_token,expires_in} =rsp.data
    //now.getTime()从 1970 年 1 月 1 日至今的毫秒数
    localStorage.setItem("login_user", JSON.stringify({access_token,refresh_token,expire:now.getTime()/1000+expires_in}))
    self.location="/"

用数据库存储token
  参考文档
  github地址 
    https://github.com/go-oauth2/oauth2
  参数设置文档
    https://go-oauth2.github.io/zh/
