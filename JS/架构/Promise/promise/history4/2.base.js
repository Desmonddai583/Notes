
let Promise = require('./promise')



let p =new Promise((resolve,reject)=>{
    resolve(new Promise((resolve,reject)=>{ // 取这个promise的成功的结果
        setTimeout(() => {
            resolve('hello')
        }, 1000);
    }))
});

p.then(data=>{
    console.log(data);
})