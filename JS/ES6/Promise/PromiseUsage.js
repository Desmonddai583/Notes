let fs = require('fs');
function read(url){
    return new Promise(function(resolve,reject){
        fs.readFile(url,'utf8',function(err,data){
            if(err)reject(err);
            resolve(data);
        })
    })
}
// 如果then中返回了一个promise会将promise的结果继续传给第二then中
// read('1.txt').then(data=>{
//    return read(data); // 如果返回了一个普通，会将这个值作为下一次then的成功会回调
// }).then(data=>{
//     console.log('$',data);
// }).catch(e=>{
//     console.log(e)
// })
// catch 的用法 ,catch可以实现错误的捕获 一般写在最后，如果上面有自己的err会走自己的error
// 如果没有写就会走到catch

// 一起读两个文件
// Promise.all方法执行后返回的依旧是promise
// all两个全成功 才表示成功 如果有一个失败了
// race赛跑 如果先成功了 那就成功了 如果先失败了 那就失败了
Promise.race([read('1.txt'),read('2.txt')]).then(data=>{
    console.log(data);
},err=>{
    console.log(err);
});
// Promise的静态方法
Promise.resolve([1,2,3]).then(function(data){
    console.log(data);
});

Promise.reject([1,2,3]).then(null,function(err){
    console.log('err',err)
}); 

// 不管promise中的then走的是成功还是失败。都会将返回值作为下一次then的成功的结果
let p = new Promise(function(resolve,reject){
    reject();
}).then(function(){

},function(){
  
    // 下一个then取的是上一次then中的返回值
}).then(function(data){
    console.log('data',data);
},function(err){
    console.log(err)
});

// then返回的结果 处理
let p = new Promise(function(resolve,reject){
    resolve()
});

p.then(function(){
    return new Promise(function(resolve,reject){
        reject(100)
    })

},function(){

}).then(function(data){
    console.log(data)
},function(err){
    console.log('err',err)
});

// 如果resolve 里面放的是promise 会将这个promise执行后的结果向下传递
let p = new Promise(function(resolve,reject){
    resolve(new Promise(function(resolve,reject){
        resolve(new Promise(function(resolve,reject){
            resolve(100);
        }))
    }))
})
p.then(function(data){
    console.log(data);
});

let promise = new Promise(function(resolve,reject){
    resolve(100)
})
promise.then(function(data){
    console.log(data);
})