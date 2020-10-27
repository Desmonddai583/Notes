const http = require('http');


http.createServer((req,res)=>{
    // 判断当前用户是移动端还是pc端 
    let userAgent = req.headers["user-agent"]; // 判断用户内核
    res.statusCode = 302;
    if(userAgent.includes('iPhone')){
        res.setHeader('Location','http://www.baidu.com');
    }else {
        res.setHeader('Location','http://www.zhufengpeixun.cn');
    }
    res.end();

}).listen(3000);

// 作业:header 进行整理
// header 使用场景 和 每个header的意义


// koa express cookie session
// vue  koa + vue 写一个完整版的内容  + mongo + redis  + nuxt