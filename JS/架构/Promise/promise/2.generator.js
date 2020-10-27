// generator es6语法 promise
// 1) 基本用法----------
// function * gen(){ // generator函数 生成器函数
//     yield 1; // 生成 产出
//     yield 2;
//     // 碰到return 这个函数才会结束
// }
// // 生成的是迭代器对象 -> next -> {value:100,done:true}
// // value就是当前迭代出来的结果 done 表示当前函数是否执行完成
// let it = gen();
// // 生成器函数和普通函数的区别在于 生成器函数具有暂停的效果
// console.log(it.next()); // 碰到yield 就会暂停
// console.log(it.next());
// console.log(it.next()); // dva koa1.0 => async + await

// yield 可以有返回值的

// 2) 返回值问题
// function * gen(){ 
//     let r1 = yield 1;
//     console.log(r1);
//     let r2 = yield 2;
//     console.log(r2);
//     return undefined
// }
// let it = gen();
// console.log(it.next(1)); // 第一次传递的值是无效的
// console.log(it.next(100)); // 当调用next方法时候传递的参数 会给上一次yield 赋值
// console.log(it.next(200));
// 1.每次调用next 碰到yield就停止
// 2.碰到return 函数就执行完毕 
// 3.当前调用next时传递的参数永远给的是上一次yield 的返回值

// 应用场景
// let fs = require('fs').promises;
// function * read(){ // 感觉写代码就是同步的写，但是执行还是异步嵌套的执行
//     let content = yield fs.readFile('./name.txt','utf8'); // 1
//     let age = yield fs.readFile(content,'utf8'); // 2
//     let ccc = yield 1234
//     return age;
// }

// co 实现 tj写的

// function co(it){
//     return new Promise((resolve,reject)=>{
//         // 如果是异步 而且是重复性 不能使用循环 循环时同步的
//         // 异步重复性工作 迭代 -> 回调
//         function next(data){
//             let {value,done} = it.next(data);
//             if(!done){
//                 Promise.resolve(value).then(data=>{
//                     next(data);
//                 },reject)
//             }else{
//                 resolve(value); // 将最终的结果 返回给当前的co的promise
//             }
//         }
//         next();
//     });
// }
// co(read()).then(data=>{
//     console.log(data);
// });


// async + await  ES7语法
// let fs = require('fs').promises;
// async function  read(){ // 感觉写代码就是同步的写，但是执行还是异步嵌套的执行
//     let content = await fs.readFile('./name.txt','utf8'); // 1
//     let age = await fs.readFile(content,'utf8'); // 2
//     let c = await 1234
//     return age;
// }
// async + await (语法糖) = generator + co

// async 返回的就是一个promise await 后面跟的内容会被包装成一个prnmise
// read().then(data=>{
//     console.log(data);
// })

// 我希望用 async + await 来模拟Promise.all

let fn1 = ()=>{
    return new Promise((resolve,reject)=>{
        setTimeout(() => {
            resolve('1');
        }, 1000);
    })
}
let fn2 = ()=>{
    return new Promise((resolve,reject)=>{
        setTimeout(() => {
            resolve('2');
        }, 2000);
    })
}
let fn3 = ()=>{
    return new Promise((resolve,reject)=>{
        setTimeout(() => {
            resolve('3');
        }, 3000);
    })
}
async function asyncAlls(promises){
    let arr = [];
    // promises.forEach(async result => { // forEach同步的 不
    //     arr.push(await result)
    // });
    for(let p of promises){
        arr.push(await p); // 会阻塞for 循环 但是我们的promise是一起执行的 所以还是以最长时间为主
    }
    return arr;
}
async function readAll() {
    console.time('timer')
    let r = await asyncAlls([fn1(),fn2(),fn3()])
    console.timeEnd('timer')
    return r
}
readAll().then(data=>{
    console.log(data);
})

// 只要 有await 必须有async  但是用async 里面可以不放await
/// * 里面可以不放yield 有yield 一定要放*


// let it = read();
// let {value,done} = it.next();
// value.then(data=>{
//     let {value,done } = it.next(data);
//     value.then(data=>{
//         let {value,done} = it.next(data);
//         console.log(value,done)
//     })
// })