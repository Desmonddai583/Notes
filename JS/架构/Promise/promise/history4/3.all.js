// let fs = require('fs');
// promise 化 把异步的node中的api 转化成 promise方法 只针对node方法
// function promisify(fn){
//     return function (...args) {
//         return new Promise((resolve,reject)=>{
//             fn(...args,function (err,data) {
//                 if(err) reject();
//                 resolve(data);
//             })
//         });
//     }
// }
// let read = promisify(fs.readFile);
// 我们可以将node中的api 转换成promise的写法 node中的回调函数有两个参数 一个err，一个是data
// read('name.txt','utf8').then(data=>{
//     console.log(data);
// })
// 各种node模块只要遵循这个参数合理 =》将异步方法 转化成promise



// Promise.all 方法表示等待所有的promise全部成功后 才会执行回调，如果有一个promise失败则promise就失败了
let fs = require('fs').promises;
const isPromise = value =>{
    if((typeof value === 'object' && value !== null) ||typeof value === 'function'){
        return typeof value.then === 'function'
    }
    return false;
}
Promise.all = function (promises) {
    return new Promise((resolve,reject)=>{
        let arr = []; // 返回的数组
        let i = 0;
        let processData = (index,data)=>{
            arr[index] = data;
            if(++i === promises.length){
                resolve(arr);
            }
        }
        for(let i = 0; i< promises.length;i++){
            let current = promises[i];
            if(isPromise(current)){
                current.then(data=>{ // 如果有任何一个promise失败了 直接让这个promise变成失败态即可
                    processData(i,data)
                },reject)
            }else{
                processData(i,current);
            }
        }
    })
}
// 让一个promise 执行 就是调用他的then方法 
// Promise.all([1,2,3,fs.readFile('name.txt','utf8'),fs.readFile('age.txt','utf8'),4,5]).then((values)=>{
//     console.log(values);
// },err=>{
//     console.log(err);
// });

// 1.Promise.race 赛跑 谁是第一个完成的 就用他的结果，如果是失败这个promise就失败，如果第一个是成功就是成功
// Promise.race([fs.readFile('name1.txt','utf8'),fs.readFile('age.txt','utf8')]).then((values)=>{
//     console.log(values);
// },err=>{
//     console.log(err);
// }); // 先到先得

// 2.promise.finally不是类上的方法
new Promise((resolve,reject)=>{
    resolve(100)
    // finally 他也是一个then方法
}).finally(()=>{ // 无论成功和失败都会执行的方法,如果finally中返回了一个promise 会等待这个promise执行完成后继续执行
    console.log('hello');
    return new Promise((resolve,reject)=>{
        setTimeout(() => {
            resolve();
        }, 1000);
    })
}).then(data=>{
    console.log('success'+data);
}).catch(err=>{
    console.log(err);
})

// 3.Promise.resolve / Promise.reject 创建成功或者失败的promise
// 把今天的内容好好的整理下 （必会的）