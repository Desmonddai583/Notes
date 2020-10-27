// Q库
Q.fcall(function () {
    return 100;
}).then(function (data) {
    console.log(data);
})

function read(url) {
    return new Promise(function (resolve, reject) {
        require('fs').readFile(url, 'utf8', function (err, data) {
            if (err) reject(err);
            resolve(data);
        })
    })
}
let Q = require('q');
Q.all([read('./2.promise/1.txt'), read('./2.promise/2.txt')]).then(function ([a1, a2]) {
    console.log(a1, a2)
});

let Q = require('q');
function read(url) {
    let defer = Q.defer();
    require('fs').readFile(url, 'utf8', function (err, data) {
        if (err) defer.reject(err);
        defer.resolve(data);
    })
    return defer.promise
}
read('./2.promise/1.txt').then(function (data) {
    console.log(data);
});


// Bluebird
let fs = require('fs');
let bluebird = require('bluebird');
let read = bluebird.promisify(fs.readFile);
bluebird.promisifyAll(fs);
fs.readFileAsync('./2.promise/1.txt', 'utf8').then(function (data) {
    console.log(data);
});

// Bluebird原理
function promisify(fn) { // promise化 将回调函数在内部进行处理
    return function (...args) {
        return new Promise(function (resolve, reject) {
            fn(...args, function (err, data) {
                if (err) reject(err);
                resolve(data);
            })
        })
    }
}
function promisifyAll(obj) {
    Object.keys(obj).forEach(key => { // es5将对象转化成数组的方法
        if (typeof obj[key] === 'function') {
            obj[key + 'Async'] = promisify(obj[key])
        }
    })
}

// co库
let co = require('co');
let bluebird = require('bluebird');
let fs = require('fs');
let read = bluebird.promisify(fs.readFile);
function* r() {
    let content1 = yield read('./2.promise/1.txt', 'utf8');
    let content2 = yield read(content1, 'utf8');
    return content2;
}
co(r()).then(function (data) {
    console.log(data)
})

// co库原理
function co(it) {
    return new Promise(function (resolve, reject) {
        function next(d) {
            let { value, done } = it.next(d);
            if (!done) {
                value.then(function (data) { // 2,txt
                    next(data)
                }, reject)
            } else {
                resolve(value);
            }
        }
        next();
    });
}
