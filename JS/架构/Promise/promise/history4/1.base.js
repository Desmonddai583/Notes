let fs = require('fs');
// Q.deferred 可以帮我们产生一个延迟对象d
let Promise = require('./promise')

function read() { // promise 为了解决嵌套的问题
    let dfd = Promise.deferred()
    fs.readFile('name1.txt', 'utf8', function (err, data) {
        if (err) {
            dfd.reject(err);
        }
        dfd.resolve(data);
    })
    return dfd.promise;
}
// promise中的catch 指代的就是 then 没有成功回调的一个别名而已
read().catch(err=>{
    console.log(err);
})