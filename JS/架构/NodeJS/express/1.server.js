// express 是一个函数
let express = require('./express');
// 通过express执行产生一个应用
let app = express();


// 当请求到来时 路径和方法一致会触发对应的函数

// vue 的路由权限校验 校验用户权限 没有权限直接结束即可

app.get('/',function (req,res) { // req,res 都是原生的node中的req和res
    // 只是可以把一个整块的代码拆分成多个步骤
    next();
});
app.get('/hello',function (req,res) { // req,res 都是原生的node中的req和res
    res.end('hello');
});
app.listen(3000);