function Promise(executor) { // executor是一个执行函数
    let self = this;
    self.status = 'pending';
    self.value = undefined; // 默认成功的值
    self.reason = undefined; // 默认失败的原因
    self.onResolvedCallbacks = []; // 存放then成功的回调
    self.onRejectedCallbacks = []; // 存放then失败的回调
    function resolve(value) { // 成功状态
        if (self.status === 'pending') {
            self.status = 'resolved';
            self.value = value;
            self.onResolvedCallbacks.forEach(function (fn) {
                fn();
            });
        }
    }
    function reject(reason) { // 失败状态
        if (self.status === 'pending') {
            self.status = 'rejected';
            self.reason = reason;
            self.onRejectedCallbacks.forEach(function (fn) {
                fn();
            })
        }
    }
    try {
        executor(resolve, reject)
    } catch (e) { // 捕获的时候发生异常,就直接失败了
        reject(e);
    }
}

function resolvePromise(promise2, x, resolve, reject) {
    // 有可能这里返回的x是别人的promise
    // 尽可能允许其他乱写
    if (promise2 === x) { //这里应该报一个类型错误，有问题
        return reject(new TypeError('循环引用了'))
    }
    // 看x是不是一个promise,promise应该是一个对象
    let called; // 表示是否调用过成功或者失败
    if (x !== null && (typeof x === 'object' || typeof x === 'function')) {
        // 可能是promise {},看这个对象中是否有then方法，如果有then我就认为他是promise了
        try { // {then:1}
            let then = x.then;
            if (typeof then === 'function') {
                // 成功
                then.call(x, function (y) {
                    if (called) return
                    called = true
                    // y可能还是一个promise，在去解析直到返回的是一个普通值
                    resolvePromise(promise2, y, resolve, reject)
                }, function (err) { //失败
                    if (called) return
                    called = true
                    reject(err);
                })
            } else {
                resolve(x)
            }
        } catch (e) {
            if (called) return
            called = true;
            reject(e);
        }
    } else { // 说明是一个普通值1
        resolve(x); // 表示成功了
    }
}

Promise.prototype.then = function (onFulfilled, onRjected) {
    //成功和失败默认不穿给一个函数
    onFulfilled = typeof onFulfilled === 'function' ? onFulfilled : function (value) {
        return value;
    }
    onRjected = typeof onRjected === 'function' ? onRjected : function (err) {
        throw err;
    }
    let self = this;
    let promise2; //返回的promise
    if (self.status === 'resolved') {
        promise2 = new Promise(function (resolve, reject) {
            // 当成功或者失败执行时有异常那么返回的promise应该处于失败状态
            // x可能是一个promise 也有可能是一个普通的值
            setTimeout(function () {
                try {
                    let x = onFulfilled(self.value);
                    // x可能是别人promise，写一个方法统一处理
                    resolvePromise(promise2, x, resolve, reject);
                } catch (e) {
                    reject(e);
                }
            })
        })
    }
    if (self.status === 'rejected') {
        promise2 = new Promise(function (resolve, reject) {
            setTimeout(function () {
                try {
                    let x = onRjected(self.reason);
                    resolvePromise(promise2, x, resolve, reject);
                } catch (e) {
                    reject(e);
                }
            })

        })
    }
    // 当调用then时可能没成功 也没失败
    if (self.status === 'pending') {
        promise2 = new Promise(function (resolve, reject) {
            // 此时没有resolve 也没有reject
            self.onResolvedCallbacks.push(function () {
                setTimeout(function () {
                    try {
                        let x = onFulfilled(self.value);
                        resolvePromise(promise2, x, resolve, reject);
                    } catch (e) {
                        reject(e)
                    }
                })
            });
            self.onRejectedCallbacks.push(function () {
                setTimeout(function () {
                    try {
                        let x = onRjected(self.reason);
                        resolvePromise(promise2, x, resolve, reject);
                    } catch (e) {
                        reject(e);
                    }
                })
            });
        })
    }
    return promise2;
}

// 捕获错误的方法
Promise.prototype.catch = function (callback) {
    return this.then(null, callback)
}

// 解析全部方法
// let arr = [];
// arr[1] = 100;
// console.log(arr.length)
Promise.all = function (promises) {
    //promises是一个promise的数组
    return new Promise(function (resolve, reject) {
        let arr = []; //arr是最终返回值的结果
        let i = 0; // 表示成功了多少次
        function processData(index, y) {
            arr[index] = y;
            if (++i === promises.length) {
                resolve(arr);
            }
        }
        for (let i = 0; i < promises.length; i++) {
            promises[i].then(function (y) {
                processData(i, y)
            }, reject)
        }
    })
}

// 只要有一个promise成功了 就算成功。如果第一个失败了就失败了
Promise.race = function (promises) {
    return new Promise(function (resolve, reject) {
        for (var i = 0; i < promises.length; i++) {
            promises[i].then(resolve,reject)
        }
    })
}

// 生成一个成功的promise
Promise.resolve = function(value){
    return new Promise(function(resolve,reject){
        resolve(value);
    })
}

// 生成一个失败的promise
Promise.reject = function(reason){
    return new Promise(function(resolve,reject){
        reject(reason);
    })
}

Promise.defer = Promise.deferred = function () {
    let dfd = {};
    dfd.promise = new Promise(function (resolve, reject) {
        dfd.resolve = resolve;
        dfd.reject = reject;
    });
    return dfd
}

module.exports = Promise;