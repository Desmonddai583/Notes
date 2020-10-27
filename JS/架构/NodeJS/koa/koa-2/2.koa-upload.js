const betterBody = require('./koa-better-body') // koa-bodyparser
const covert = require('koa-convert')
const Router = require('@koa/router');
const path = require('path');
const Koa = require('koa');
const views = require('koa-views');
const app = new Koa();
const router = new Router();
app.use(betterBody({ // formidable
    uploadDir:path.resolve(__dirname,'uploads')
}));
app.use(views(path.join(__dirname,'views'),{
    map:{
        html:'ejs'
    }
}));
// 这里为了保证其他中间件先加载 我把koa-router 放到最后来加载 确保可以使用 ctx.render方法
app.use(router.routes()); // 挂载路由
app.use(router.allowedMethods()) // 405 后端不支持某个方法时会显示405

// 父路由 挂载子路由
const user = require('./routes/user');
const profile = require('./routes/profile');
router.use(profile.routes());
router.use('/user',user.routes());

router.all('*',async ctx=>{
    ctx.body = '没找到'
})

app.listen(3000);
// 路由  根据不同的路径和方法 返回对应的结果
// app.use(async (ctx,next)=>{
//     if(ctx.path === '/upload' && ctx.method === 'GET'){
//          await ctx.render('index.html')
//     }else{
//         await next();
//     }
// });
// app.use(async ctx=>{
//     if(ctx.path === '/upload' && ctx.method === 'POST'){
//         ctx.body = ctx.request.files
//     }else{
//         ctx.body = '没找到 '
//     }
// });


// a=b&c=d  {}  formdata


