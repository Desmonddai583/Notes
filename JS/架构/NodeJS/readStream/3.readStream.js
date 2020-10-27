// 使用可读流  内部是发布订阅， 读取出来你就告诉我 我自己去写
// 流 基于事件的 Events模块


// 文件流:有打开和关闭的方法 
let fs = require('fs');
let ReadStream = require('./ReadStream');
// let rs = fs.createReadStream('./name.txt',{
let rs = new ReadStream('./name.txt',{
    flags:'r',  // fs.open 
    encoding: null, // 默认就是buffer
    mode:0o666, // fs.open
    autoClose:true, // fs.close
    //emitClose:false, // 触发close事件
    start:2, // 包前又包后 0-3个字符 4个字节
    end:4,
    highWaterMark:2 // 表示的是每次读几个  64*1024 默认一口气读取出来64k
});
rs.on('open',(fd)=>{
    console.log('文件打开了')
});
// 默认可读流是暂停模式的 => 流动模式
let arr = [];
rs.pause();
rs.on('data',function(data){
    console.log(data);
    arr.push(data);
    rs.pause(); // 暂停触发data事件
});
// setTimeout(() => {
//     rs.resume();
// }, 1000);
rs.on('end',function(){
    console.log( Buffer.concat(arr).toString());
})
// 等到文件读取完毕后 才会触发close事件
rs.on('close',()=>{
    console.log('文件关闭了')
});
rs.on('error',(err)=>{
    console.log(err);
})
// 文件流独有的:open close   data end 数据拼接要使用Buffer.concat()方法