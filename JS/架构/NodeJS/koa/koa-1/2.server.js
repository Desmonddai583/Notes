const Koa = require('./koa');
// 创建app的应用
let app = new Koa();

app.use((ctx)=>{
    // console.log(ctx.req.path); // 原生的url
    // // 自己封装的request上有原生的req属性
    // console.log(ctx.request.req.path); 
    // // pathname  => url.parse()
    // console.log(ctx.request.path); // 自己封装的url属性
    // // 简写
    // console.log(ctx.path); // 他表示的是 ctx.request.url
    ctx.body = 'hello';
    ctx.body = 'world';
    // ctx.response.body = 'hello';
    console.log(ctx.response.body)
});
// req 和 request的区别   request.req = req;
// ctx.path = ctx.request.path 内部就是defineProperty 代理

app.listen(3000,()=>{
    console.log(`server start 3000`)
});
// ctx 包含了原生的请求 和响应  req ，res
//     包含了自己封装的请求和响应 request response

