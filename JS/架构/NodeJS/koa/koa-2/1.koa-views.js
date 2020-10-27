// 核心包 koa  koa-static  koa-bodyparser  koa-views
// (ejs jade nunjucks)
const Koa = require('koa');
const views = require('./koa-views');
const path = require('path')
const app = new Koa();
// ssr http-server

// 什么叫中间件 能解决哪些问题
// 1.可以封装属性和方法 ctx.request.body  
// 2.提前的处理请求  给koa 提前处理静态资源
// 3.权限相关 有权限就继续向下执行 没权限直接返回即可


app.use(views(path.join(__dirname,'/views'),{
    map:{
        html:'ejs',
    }
}))

app.use(async ctx=>{
     await ctx.render('index',{name:'zf',age:10,arr:[4,5,6]})
})


app.listen(3000);