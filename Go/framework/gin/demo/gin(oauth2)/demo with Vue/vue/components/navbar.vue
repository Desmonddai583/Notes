<template>
    <div>
        <el-breadcrumb separator="/">
            导航栏 <router-link :to="{ path: '/' }">首页</router-link>
            <template v-if="isLogin">
                欢迎你：{{currentUser}} <a href="#" @click="logout">注销</a>
            </template>
            <template v-else>
                <router-link :to="{ path:'/login' }">登录</router-link>
            </template>


        </el-breadcrumb>
    </div>

</template>
<script>
    module.exports={
        data(){
            return {
                isLogin: false,
                currentUser: ''
            }
        },
        created(){
            const getToken = localStorage.getItem("login_user")
            if(getToken!==null  && getToken!== ''){
                const {access_token} = JSON.parse(getToken)
                axios.post("http://oauth.me.com/info",{},{
                    headers:{
                        "Authorization":"Bearer " + access_token
                    }
                }).then((rsp) => {
                    this.isLogin = true
                    console.log(rsp.data)
                    const {user_id}=rsp.data
                    this.currentUser = user_id
                })
            }
        },
        methods:{
            logout(){
                const getToken = localStorage.getItem("login_user")
                if(getToken!==null  && getToken!== ''){
                    const {access_token} = JSON.parse(getToken)
                    localStorage.removeItem("login_user")
                    self.location='http://oauth.me.com/logout?access_token='+access_token
                    +"&redirect_uri="+encodeURIComponent("http://me.com")
                }else{
                    self.location="/" //直接跳首页
                }


            }
        }
    }

</script>
