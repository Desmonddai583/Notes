// Promise.resolve Promise.reject 表示一上来就创建成功的promise或者失败的promise
// 1) ----------------
// 静态方法

// Promise.resolve 他会等待里面的promise执行成功
// Promise.reject 不会等待参数中的promise执行完毕

// Promise.resolve = function (value) {
//     return new Promise((resolve,reject)=>{
//         resolve(value); // resolve方法里放一个promise 会等待这个promise执行完成
//     })
// }
// Promise.reject = function (value) {
//     return new Promise((resolve,reject)=>{
//         reject(value); // reject 并不会解析promise值
//     })
// }
// Promise.resolve(new Promise((resolve,reject)=>{setTimeout(() => {
//     resolve(1000)
// }, 1000)})).then(err=>{
//     console.log(err);
// })

// Promise.prototype.finally 无论如何都执行
// 2) ----------------
// Promise.prototype.finally = function (callback) {
//     return this.then((value)=>{
//         // 等待finally方法执行完毕后 将上一个成功的结果向下传递
//         return Promise.resolve(callback()).then(()=>value); 
//     },(err)=>{
//         return Promise.resolve(callback()).then(()=>{throw err});
//     })
// }
// Promise.resolve(100).finally(()=>{
//     console.log('finally');
//     return new Promise((resolve,reject)=>{ // 默认会等待当前finally方法执行完毕
//         setTimeout(() => {
//             resolve('hello');
//         }, 1000);
//     })
// }).then((data)=>{
//     console.log('success:'+data)
// },(fail)=>{
//     console.log('error:'+fail)
// })


// 3) -----------------
// let p1 = new Promise((resolve, reject) => {
//     setTimeout(() => {
//         resolve('hello');
//     }, 1000);
// })
// let p2 = new Promise((resolve, reject) => {
//     setTimeout(() => {
//         reject('hello');
//     }, 1900);
// })
// race 就是默认等到最先成功的promise的状态
// const isPromise = (promise) => { // 判断他必须是一个对象 或者函数
//     return typeof promise.then === 'function';
// }
// Promise.race = function (promises) {
//     return new Promise((resolve, reject) => {
//         // 谁返回的结果最快 就用谁的
//         for (let i = 0; i < promises.length; i++) {
//             let current = promises[i];
//             if (isPromise(current)) { // 采用第一个调用resolve 或者reject的结果
//                 current.then(resolve, reject)
//             } else {
//                 resolve(current);
//             }
//         }
//     })
// }
// Promise.race([p1, p2, p1, p2, p1, p2]).then(data => {
//     console.log(data)
// }, err => {
//     console.log('error' + err)
// });

// race应用场景

let p = new Promise((resolve, reject) => {
    setTimeout(() => {
        resolve(123);
    }, 1000); // 要等待3s 之后变成成功态
})
// 这里并不是让p 变成失败态 ，而是做一个超时处理 超过2s 后不再采用p的成功结果了
function wrap(p){
    let abort;
    let p1 = new Promise((resolve,reject)=>{
        abort = reject;
    });
    // race 方法 来在内部构构建一个promise 将这个promise和传递promise组成一个race,如果用户调用了p1的abort方法 相当于让p1 失败了 = Promise.race失败了
    let newPromise = Promise.race([p1,p])
    newPromise.abort = abort
    return newPromise
}
let p1 = wrap(p);
p1.then(data => {
    console.log('success', data)
}, err => {
    console.log('error', err)
})
setTimeout(() => {
    p1.abort('超过2s了');
}, 2000);
