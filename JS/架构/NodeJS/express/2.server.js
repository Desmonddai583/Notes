const express = require('./express')
const app = express();

// next向下执行
app.get('/a',function (req,res,next) {
    // 路由中间件 可以在这里做一个提前处理如果没有达到预期 就不在继续执行了 
    next();
  
},function (req,res,next) {
    console.log(3);
    next();
    console.log(4);
})
app.get('/a',function (req,res,next) {
    console.log(5)
    res.end('end')
})
app.listen(3000);

// 和koa 一样 next 前后都会执行