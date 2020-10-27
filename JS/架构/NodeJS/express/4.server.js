let express =require('./express');
let app = express();
// next中如果传递了参数 就表示出错了 ，出错后会跳过所有的中间件和路由 找到错误处理中间件

// 中间件的next 和路由中的next 是否是同一个next?
app.use(function (req,res,next) {
    // 如果用户请求的路径 是 /a 的话就需要出错
    // if(req.url == '/a'){
    //     next('error 路径是/a my')
    // }else{
        next();
    // }
})
app.use((function (req,res,next) {
    console.log('middleware')
    next();
}))
app.get('/a/b',function(req,res,next){
    next('error fail')
},function (req,res,next) {
    res.end('/b')
});
// 错误处理中间件 一般放在当前页面的最底部 参数有4个
app.use(function (err,req,res,next) {
    res.end(err);
})
app.listen(3000);