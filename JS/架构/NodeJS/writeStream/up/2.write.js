// 我们希望把10个数写入到文件中 依次写入
// 1.直接用10个字节的内存来写入
// 2.写完一个在写第二个


let fs = require('fs');
let path = require('path');

let ws = fs.createWriteStream(path.resolve(__dirname,'name.txt'),{
    highWaterMark:3// 我期望占用的内存是多少
});

let index = 0;
let flag = true;
// 可以通过flag 来实现控制写入的时机，只是一个参考的标准
function write(){
    flag = true;
    while (index != 10 && flag) { // 第一次写入是向文件中写入，剩下的需要在内存中排队
         ws.write(index++ + ''); // 内部只能传入 buffer和string的格式
    }
}
write();
// 当我们写入的内容 达到了预估的标准之后，并且数据被清空了就会触发drain事件
ws.on('drain',function () {
    console.log('drain')
    write();
});