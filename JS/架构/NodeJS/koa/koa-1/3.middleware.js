const Koa = require('./koa');
const app = new Koa();
const sleep = async ()=>{
    await new Promise((resolve,reject)=>{
        setTimeout(() => {
            console.log('睡觉')
            resolve();
        }, 1000);
    })
}
// koa 里面用的是洋葱模型 把方法都套起来  co -> next
// koa中可以使用async + await方法
// 我们执行koa时  每个next 方法都需要前面都要增加await 否则不会有等待效果
// koa为了统一处理错误  就将每个函数都转化成promise ，为了方便错误处理

// 整理http的header
// 用reduce() 来实现函数的组合  （redux-compose）

app.use(async function (ctx,next) {
    // console.log(1);
    // await next(); // 这里只是调用next函数并没有等待的效果
    // next();
    // next()
    // console.log(2);
    next();
    next();
})
// app.use(async function (ctx,next) {
//     console.log(3);
//     await sleep();
//     await next();
//     console.log(4);
// })
// app.use(function (ctx,next) {
//     console.log(5);
//     // throw new Error('我错了');
//     next();
//     console.log(6);
// })
app.on('error',function (err) {
    console.log(err);
})
app.listen(3000);


// 把多个promise 组合成一个promise 这个promise完成后 去拿最终的结果显示给用户
