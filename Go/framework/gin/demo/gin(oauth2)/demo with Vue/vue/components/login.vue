<template>
    <div>
      <el-button @click="login" >点这里到用户中心登录</el-button>
    </div>

</template>
<script  type="module">
    var config={
        //请求授权地址
        userAuthorizationUri:"http://oauth.me.com/auth",
        //accessToken请求地址
        accessTokenUri : "http://oauth.me.com/token",
        //回调地址
        redirect_uri : "http://me.com/#/auth_code", //下节课再改
        client_id:"mainweb",
        //申请的权限范围,这里不做处理
        scope:"all",
        //state这里不做处理，随便写
        state:"me.com",
        grant_type : "authorization_code",
        code:"",
    }
   module.exports ={
       data(){
           return {

           }
       },
       methods: {
            login(){
                self.location= config.userAuthorizationUri + ('?' + Qs.stringify({
                    client_id:config.client_id,
                    response_type:"code",
                    scope:config.scope,
                    state:config.state,
                    redirect_uri:config.redirect_uri,
                }))
                 //alert(authorUrl)



            }
       }
   }
</script>