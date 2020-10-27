// Buffer是global上的属性
// 申请内存 可以存放 图片 文本
// 他长得很像数组
let buffer = Buffer.alloc(6, 1); // 这种申请方式内存永远是干净的,声明也比较耗时

let buffer = Buffer.allocUnsafe(6); // 他声明buffer比较快
buffer.fill(1, 3, 5); // 没用的部分可以帮我们清空
let buffer = Buffer.alloc(6, 1); // 你知道buffer存的都是16进制 
console.log(buffer);

// 1）通过长度来申请
// 2）通过字符串来申请
console.log(Buffer.from('珠峰培训')); // 不支持gbk node中只支持utf8 

// 3）通过数组构建buffer
console.log(Buffer.from([16, 17, 18]));

// 把buffer和字符串进行转化
let buffer = Buffer.alloc(12);
let buf1 = '珠'
let buf2 = '峰培训'
// 写入的内容 ， 偏移量 , 长度
buffer.write(buf1, 0, 3, 'utf8');
buffer.write(buf2, 3, 9, 'utf8');
console.log(buffer.toString());


let buffer = Buffer.alloc(12);
let buf1 = '珠峰培'
let buf2 = '训' // 训珠峰培

buffer.write(buf1, 3, 9);
buffer.write(buf2, 0, 3);
console.log(buffer.toString())


// slice   copy   concat   indexOf split
// slice是深拷贝还是浅拷贝
let arr = [1, [1], 3, 4];
let newArr = arr.slice(1, 2);
newArr[0][0] = 2;
console.log(arr);
// buffer和数组中的二维数组是一样的 buffer里存的都是内存地址

let buffer = Buffer.alloc(6, 1);
let newBuffer = buffer.slice(0, 3);
newBuffer[0] = 100;
console.log(buffer);

let buffer = Buffer.alloc(6);
let buf1 = Buffer.from('姜');
let buf2 = Buffer.from('培');
//  培姜
// targetBuffer offset sourceStart sourceEnd
Buffer.prototype.myCopy = function (targetBuffer, offset, sourceStart, sourceEnd) {
    for (let i = sourceStart; i < sourceEnd; i++) {
        targetBuffer[offset++] = this[i];
    }
}
buf1.myCopy(buffer, 3, 0, 3);
buf2.myCopy(buffer, 0, 0, 3);
console.log(buffer.toString());


// Buffer
let buffer1 = Buffer.from('姜');
let buffer2 = Buffer.from('文');
// 多写的内容就是0
// http tcp  
Buffer.myconcat = function (list, totalLength) {
    if (list.length == 1) {
        return list[0];
    }
    if (typeof totalLength === "undefined") {
        totalLength = list.reduce((prev, next) => {
            return prev + next.length
        }, 0)
    }
    let buf = Buffer.alloc(totalLength); // 创建这么大的buffer
    let pos = 0; // 记忆当前拷贝的位置
    list.forEach(function (buffer, index) { // [[1,2,3],[4,5,6]]
        for (var i = 0; i < buffer.length; i++) {
            buf[pos++] = buffer[i];
        }
    })
    return buf.fill(0, pos)
}

console.log(Buffer.myconcat([buffer1, buffer2, buffer1, buffer2]));


let buffer = Buffer.from('珠峰-珠-培-珠-训');
console.log(buffer.indexOf('--',8)); // buffer的indexOf取的是buffer的长度
// split 分割方法  [buffer6,buffer3,buffer3];
Buffer.prototype.split = function(sep){ //
    let arr = [];
    let len = Buffer.from(sep).length;
    let pos = 0;
    while(-1!=(index = this.indexOf(sep,pos))){
        arr.push(this.slice(pos,index));
        pos = index+len
    }
    arr.push(this.slice(pos))
    return arr;
}
console.log(buffer.split('珠').map(item=>item.toString()));
// 后面会用到



// gb2312 一个汉字几个字符 

let fs = require('fs');
let path = require('path');

/**
 * Remove byte order marker. This catches EF BB BF (the UTF-8 BOM)
 * because the buffer-to-string conversion in `fs.readFileSync()`
 * translates it to FEFF, the UTF-16 BOM.
 */
function stripBOM(content) {
    if (Buffer.isBuffer(content)) {
        if (content[0] === 0xEF && content[1] === 0xBB && content[2] === 0xBF) {
            return content.slice(3)
        }
        return content;
    } else {
        if (content.charCodeAt(0) === 0xFEFF) {
            content = content.slice(1);
        }
        return content;
    }
}
// utf8 是unicode是他的实现
let result = fs.readFileSync(path.join(__dirname, './1.txt'), 'utf8');
result = stripBOM(result);
// 截取bom头
console.log(result.toString());


// 爬虫  淘宝可能就是gbk 把gbk转化程utf8
// iconv-lite
let iconv = require('iconv-lite'); // 这个模块就是一个解析其他编码的
let fs = require('fs');
let path = require('path');
let result = fs.readFileSync(path.join(__dirname, './2.txt'));
// 爬虫 我们会分析页面解构 根据编码类型来做处理
result = iconv.decode(result,'gbk');
console.log(result.toString());


// Buffer 的乱码问题
let buffer = Buffer.from('珠峰培训');
let buff1 =  buffer.slice(0,5);
let buff2 = buffer.slice(5);
let {StringDecoder} = require('string_decoder');
let sd = new StringDecoder();
console.log(sd.write(buff1).toString());
console.log(sd.write(buff2).toString());
// 模块来解决输出问题 string_decoder 我不识别的不输出 先攒着