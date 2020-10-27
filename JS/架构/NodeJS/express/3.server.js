let express = require('./express');
let app = express();
// 中间件的特点
// 1.可以决定是否继续向下执行 next
// 2.做一些权限判断 
// 3.扩展req和res 扩展属性或者方法
app.use(function(req,res,next){ console.log('空')
    req.a = 1;
    next();
})
// 中间件中如果不传入路径 默认就是/ 只要路径以/开头表示这个中间件就会执行
app.use('/',function (req,res,next) { 
    console.log('/')
    req.a++; 
    next();
})
// 只针对/a开头的路径进行匹配
app.use('/a',function (req,res,next) { // cookie path  
    console.log('/a')
    req.a++;
    next();
})
app.get('/a',function (req,res) {
    console.log(req.a);
    res.end('get /a');
})
app.listen(3000);