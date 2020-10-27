let fs = require('fs');
let path = require('path');
let ws = fs.createWriteStream(path.resolve(__dirname,'name.txt'),{
    flags:'w',
    encoding:'utf8',// 文件中存放的都是二进制
    mode:438,
    autoClose:true,
    start:0,
    highWaterMark:5 // 代表的不是每次只能写16k 而是一个预估的量
})
// 累计写入的内容 达到了我的预估量 就会返回false
let flag = ws.write('1',function () {
    console.log('写入hello ok')
}); // fs.write
// 判断是可读流(on('data') on('end'))还是可写流 (ws.write ws.end)

// 多个异步操作会被在内部排队，依次调用
console.log(flag);
flag = ws.write('2',function () {
    console.log('写入world')
}); 
flag = ws.write('3',function () {
    console.log('写入world')
}); 
ws.end('hello'); // 如果已经关闭了 不能再次写入  ws.write() + close()
// ws.write('a'); //  write after end 已经关闭就不能再次写入了

console.log(flag);

