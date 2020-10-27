const Koa = require('koa'); // babel
const app = new Koa(); // 创建一个app实例
// 请求到来时会执行此方法
app.use((ctx)=>{
    ctx.body = 'hello'
});
app.listen(3000);

// 1.listen
// 2.use 方法
// 3.ctx 上下问对象
// 4.监控错误

// 目录结构
// application 应用文件 默认引用的
// req/res (node中的默认的 req,res)
// request response (这个属性是koa自己封装的)
// context 上下文 整合 req\res\request\response