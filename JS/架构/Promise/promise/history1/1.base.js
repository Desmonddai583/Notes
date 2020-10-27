// 什么是promise 解决哪些问题的  (基于回调)
// 1.回调地狱 (代码不好维护，错误处理非常的麻烦不能统一处理错误)
// 2.多个请求的并发问题  (之前写的并发读取文件，自己定义定时器)

// Promise 是一个类 类只需要用的时候new一下

// 1.在new Promise是需要传递一个执行器函数，executor 这个函数默认就会被执行 立即执行
// 2.每个promise 都有三个状态 pending 等待态 fulfilled 成功态 rejected 失败态 
// 3.默认创建一个promise 是等待态 默认提供给你两个函数 resolve让promise变成成功态,reject让promise变成失败态
// 4.每个promise的实例都具备一个then方法 then方法中传递两个参数1.成功的回调 2.失败的回调
// 5.如何让promise变成失败态 reject() / 可以抛出一个错误 
// 6.如果多次调用成功或者失败 只会执行第一次， 一旦状态变化了 就不能在变成成功或者失败了

// 1.自己实现基本的promise
// 2.语法 commonjs规范 我们可以在一个模块中导出一个变量 ，另一个模块来引用
let Promise = require('./promise')
let promise = new Promise((resolve,reject)=>{

     reject('reason');
     resolve('value')
     throw new Error('我失败了');
})
promise.then((success)=>{
    console.log('success',success)
},(err)=>{
    console.log('fail',err)
});