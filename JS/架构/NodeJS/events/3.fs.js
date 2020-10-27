// fileSystem缩写 readFile readFileSync
// 同步 异步

// read write 
// 读取的编码没有指定的化都是buffer类型
// 默认写都会转化成utf8格式来进行存储 （并且会将文件清空，如果文件没有会创建文件） 

// 实现拷贝功能
let fs = require('fs');
let path = require('path');
// 在代码运行期间最好使用异步，运行期间使用同步代码会造成阻塞问题

// r读取的意思 
// w写的意思
// a追加
// r+ 可读可写 以读取为准 读取不到就报错
// w+ 可写可读 以写为主 找不到九创

// 这种拷贝不适合大文件进行操作
// 如果大文件操作 需要先读取到内存中，之后将文件写入，可能会浪费掉大量内存

// 流

// 如果文件超过64k 就使用流的方式， 如果要是小于64k 可以直接read write
fs.readFile(path.resolve(__dirname, 'a.txt'), function (err, data) {
    if (err) {
        console.log(err);
    } else {
        fs.appendFile(path.resolve(__dirname, 'b.txt'), data, function (err) {
            console.log('写入成功')
        })
    }
})