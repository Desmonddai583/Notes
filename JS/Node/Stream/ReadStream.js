// 流 node里很多内容都应用到了流
// 流的特点有序，有方向的
// 可读流  可写流
// 对文件操作用的也是fs模块

let fs = require('fs');
let path = require('path');
let ReadStream = require('./ReadStream')
// socket req
// 返回的是一个可读流对象
let rs = new ReadStream(path.join(__dirname,'1.txt'),{
    flags:'r', // 文件的操作是读取操作
    encoding:'utf8', // 默认是null null代表的是buffer
    autoClose:true, // 读取完毕后自动关闭
    highWaterMark:3,// 默认是64k  64*1024b
    start:0, // 123 456 789  
    //end:3 // 包前又包后
});
// 默认情况下 不会将文件中的内容输出
// 内部会先创建一个buffer先读取3b

// 非流动模式 / 暂停模式
// 流动模式会疯狂的触发data事件，直到读取完毕
// rs.setEncoding('utf8');
rs.on('open',function(){
    console.log('文件打开了')
});
rs.on('close',function(){
    console.log('关闭')
});
rs.on('error',function(err){
    console.log(err);
});

// newLisenter
rs.on('data',function(data){ // 暂停模式 -> 流动模式
    console.log(data);
    rs.pause(); // 暂停方法 表示暂停读取，暂停data事件触发
});

rs.on('end',function(){
    console.log('end')
});