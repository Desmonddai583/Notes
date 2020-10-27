// session 前后端不分离 服务端渲染
const Koa = require('koa');
const body = require('koa-bodyparser');
const path = require('path')
const views = require('koa-views');
const Router = require('koa-router');
const session = require('koa-session')
// XvHtNhhmnsKcy9g_6J_5wjnpr-Y

// const crypto = require('crypto');
// let r = crypto.createHmac('sha1','zf').update(`name=zf`).digest('base64');
// console.log(r);
let app = new Koa();
let router = new Router();
app.use(body());
app.use(views(path.resolve(__dirname,'views'),{
    map:{
        html:"ejs"
    }
}));
// 设置session 可以设置cookie参数
app.keys = ['zf']
app.use(session({httpOnly:true},app));
// koa 内置了 cookie的设置方法
app.use(router.routes());
router.get('/',async (ctx,next)=>{
    return ctx.render('home.html');
});
router.post('/login',async (ctx,next)=>{
    let {username,password} = ctx.request.body;
    if(username == 'admin' && password =='admin'){
        ctx.session.user = {username}
        ctx.redirect('/list');
    }else{
        ctx.redirect('/')
    }
});
router.get('/list',async (ctx,next)=>{
    let {username } = ctx.session.user || {};
    if(username){
        return ctx.render('list.html',{username});
    }else{
        ctx.redirect('/')
    }
});
// router.get('/read',async (ctx,next)=>{
//     ctx.body = ctx.cookies.get('name')
// })
// router.get('/write',async (ctx,next)=>{
//     ctx.cookies.set('name','zf',{signed:true})
//     ctx.body = 'ok'
// })
app.listen(3000);

// 当用户 访问 首页就渲染home.html
// 如果有户在首页登录后可以跳转到列表页 , 之后访问列表页都可以直接访问 
// 没有登录的情况下不能直接访问list.html
