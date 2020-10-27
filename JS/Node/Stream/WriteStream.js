let fs = require('fs');

let ws = fs.createWriteStream('./1.txt',{
    flags:'w',
    mode:0o666,
    autoClose:true,
    highWaterMark:3, // 默认写是16k
    encoding:'utf8',
    start:0
});
// 写入的数据必须是字符串或者buffer
// flag代表是否能继续写
// 表示符表示的并不是是否写入 表示的是能否继续写，但是返回false 也不会丢失，就是会把内容放到内存中
let flag = ws.write(1+'','utf8',()=>{}); // 异步的方法
console.log(flag);
flag = ws.write(1+'','utf8',()=>{}); // 异步的方法
console.log(flag);
// flag = ws.write(1+'','utf8',()=>{}); // 异步的方法
// console.log(flag);

//ws.end('ok'); // 当写完后 就不能再继续写了
//ws.write('123'); //write after end
// 就两个方法 write end

// 抽干方法 当都写入完后会触发drain事件
// 必须缓存区满了 满了后被清空了才会出发drain
ws.on('drain',function(){
    console.log('drain')
});

// 写的时候文件不存在 会创建文件
let ws = fs.createWriteStream(path.join(__dirname,'1.txt'),{
    highWaterMark:3,
    autoClose:true,
    flags:'w',
    encoding:'utf8',
    mode:0o666,
    start:0,
});
// 写内容的时候 必须是字符串或者buffer
for(var i = 0;i<9;i++){
   let flag =  ws.write(i+''); // 第一次写一个字符
   console.log(flag)
}
// 当文件被清空的时候才会改成true