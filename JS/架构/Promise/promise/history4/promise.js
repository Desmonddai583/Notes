console.log('-------------- my ---------------')
// 宏
const PENDING = 'PENDING' // 等待态 
const FULFILLED = 'FULFILLED' // 成功态
const REJECTED = 'REJECTED' // 

const resolvePromise = (promise2, x, resolve, reject) => {
    // 判断 可能你的promise要和别人的promise来混用
    // 可能不同的promise库之间要相互调用
    if (promise2 === x) { // x 如果和promise2 是同一个人 x 永远不能成功或者失败，所以就卡死了,我们需要直接报错即可
        return reject(new TypeError('Chaining cycle detected for promise #<Promise>'));
    }
    // ------ 我们要判断x的状态  判断x 是不是promise-----
    // 1.先判断他是不是对象或者函数
    if ((typeof x === 'object' && x !== null) || typeof x === 'function') {
        // x 需要是一个对象或者是函数
        let called; // 为了考虑别人promise 不健壮所以我们需要自己去判断一下，如果调用失败不能成功，调用成功不能失败，不能多次调用成功或者失败
        try{
            let then = x.then; // 取出then方法 这个then方法是采用defineProperty来定义的
            if(typeof then === 'function'){
                // 判断then是不是一个函数，如果then 不是一个函数 说明不是promise 
                // 只能认准他是一个promise了 
                then.call(x, y =>{ // 如果x是一个promise 就采用这个promise的返回结果
                    if(called) return;
                    called = true
                    resolvePromise(promise2, y, resolve, reject); // 继续解析成功的值
                },r=>{
                    if(called) return;
                    called = true
                    reject(r); // 直接用r 作为失败的结果
                })
            }else{
                // x={then:'123'}
                resolve(x);
            }
        }catch(e){
            if(called) return;
            called = true
            reject(e); // 去then失败了 直接触发promise2的失败逻辑
        }
    } else {
        // 肯定不是promise
        resolve(x); // 直接成功即可
    }
}
class Promise {
    constructor(executor) {
        this.status = PENDING; // 默认是等待态
        this.value = undefined;
        this.reason = undefined;
        this.onResolvedCallbacks = []; // 存放成功时的回调
        this.onRejectedCallbacks = []; // 存放失败时的回调
        let resolve = (value) => {
            if(value instanceof Promise){ // 直到解析出一个普通值来
                return value.then(resolve,reject)
            }
            if (this.status === PENDING) {
                this.status = FULFILLED
                this.value = value
                this.onResolvedCallbacks.forEach(fn => fn());
            }
        }
        let reject = (reason) => {
            if (this.status === PENDING) {
                this.status = REJECTED
                this.reason = reason
                this.onRejectedCallbacks.forEach(fn => fn());
            }
        }
        try { // try + catch 只能捕获同步异常
            executor(resolve, reject);
        } catch (e) {
            console.log(e);
            reject(e)
        }
    }
    // 只要x 是一个普通值 就会让下一个promise变成成功态
    // 这个x 有可能是一个promise,我需要采用这个promise的状态
    then(onFulfilled, onRejected) {
        // 可选参数的处理
        onFulfilled = typeof onFulfilled === 'function'?onFulfilled:val=>val;  
        onRejected = typeof onRejected === 'function'?onRejected:err=>{throw err}
        // 递归
        let promise2 = new Promise((resolve, reject) => {
            if (this.status === FULFILLED) {
                setTimeout(() => {
                    try {
                        let x = onFulfilled(this.value);
                        resolvePromise(promise2, x, resolve, reject)
                    } catch (e) {
                        reject(e);
                    }
                }, 0);
            }
            if (this.status === REJECTED) {
                setTimeout(() => {
                    try {
                        let x = onRejected(this.reason);
                        resolvePromise(promise2, x, resolve, reject)
                    } catch (e) {
                        reject(e);
                    }
                }, 0);
            }
            if (this.status === PENDING) {
                this.onResolvedCallbacks.push(() => {
                    setTimeout(() => {
                        try {
                            let x = onFulfilled(this.value);
                            resolvePromise(promise2, x, resolve, reject)
                        } catch (e) {
                            reject(e);
                        }
                    }, 0)
                });
                this.onRejectedCallbacks.push(() => {
                    setTimeout(() => {
                        try {
                            let x = onRejected(this.reason);
                            resolvePromise(promise2, x, resolve, reject);
                        } catch (e) {
                            reject(e);
                        }
                    }, 0)
                })
            }
        })

        return promise2;
    }

    catch(errCallback){ // 就是一个没有成功的then
        return this.then(null,errCallback)
    }
}
// 静态方法 类上的方法
Promise.deferred = function () {
    let dfd = {};
    dfd.promise = new Promise((resolve,reject)=>{
        dfd.resolve = resolve;
        dfd.reject = reject;
    })
    return dfd;
}
module.exports = Promise;
// sudo npm install promises-aplus-tests -g
// promises-aplus-tests promise.js
