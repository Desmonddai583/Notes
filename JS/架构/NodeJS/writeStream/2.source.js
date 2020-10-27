// 可读流 和 可写流 包含 文件的流的
let {
    Readable,
    Writable,
    Duplex,
    Transform
} = require('stream');


// Readable read() 实例可以调用read方法  调用read方法时会调用子类实现的_read()   push()
// createReadStream extends Readable
// createReadStream 需要实现 _read()

let fs = require('fs');


// 可读流：
// 默认当我们创建可读流后 会打开文件 内部会调用Readable中的read方法，这个read方法会调用子类实现的_read放，由于内部createReadStream是一个文件流，需要用fs.read方法来读取内容，读取到的内容需要调用父类的push方法,将读取的数据传入进去，最终就会触发data事件

// 可写流：
// 默认创建可写流后会打开文件，内部什么都不会做,如果用调用了 write方法，这个方法是writable提供的,内部会调用writeStream里的_write方法，这个方法里调用的就是fs.write方法。


// 5)pipe 拷贝
let ReadStream = require('./ReadStream');
let WriteSteam = require('./WriteStream')
// let r = new ReadStream('./name.txt', {
let r = fs.createReadStream('./name.txt');
// let w = new WriteSteam('./name1.txt', {
let w = fs.createWriteStream('./name1.txt');

// 异步的拷贝 缺点就是这样的写法你看不到读取的过程
// 如果希望获取结果（拿到拷贝的结果）需要等待pipe完成后才可以 
r.on('data',function (data) {
    console.log(data);
})
r.pipe(w); // 最 终读取的一个语法糖

// 4) 转换流 压缩  读取完毕后 压缩 写入到文件中
// class MyTransform  extends Transform{
//     _transform(){

//     }
// }

// 3) 双工流 
// class MyDuplex extends Duplex{
//     _write(){
//         // 自己实现write
//     }   
//     _read(){
//         // 自己实现的read
//     }
// }
// let duplex = new Duplex;


// 2)自定义可写流
// class MyWriteStream extends Writable{
//     _write(chunk,encoding,cb){ // 可写流自己实现的方法，在完成后必须要调用cb = clearBuffer
//         console.log(chunk)
//         cb();
//     }
// }
// let ws = new MyWriteStream();
// ws.write('ok')
// ws.write('ok')


// 1)自定义可读流
// class MyReadStream extends Readable {
//     _read(){ // 子类需要提供一个方法 ，只需要将数据放到push方法中即可
//         this.push('123');
//         this.push(null);
//     }
// }
// let my = new MyReadStream();

// my.on('data',function (data) {
//     console.log(data);
// })

// my.on('end',function () {
//     console.log('end');
// })


// createWriteStream extends Writeable