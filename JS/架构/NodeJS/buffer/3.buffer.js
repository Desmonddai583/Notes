// let buffer = Buffer.from('珠峰'); // buffer 是内存 截取出来的就是内存地址
// let buf1 = buffer.slice(0, 3);
// buf1[0] = 100; // 特点是默认截取出来的是内存空间，所以更改后原来的buffer也会发生变化
// console.log(buffer);


// console.log(buffer.length); // 指代的是字节长度 不是字符串长度
// console.log(Buffer.isBuffer(buf1))

// buffer固定大小的，没有pop push shift 没有改变长度的方法
// 实现扩容 就是找一个更大的空间 将现在的buffer拷贝进去

let buffer1 = Buffer.from('珠峰'); // 0-5
let buffer2 = Buffer.from('架构');
// let buff = Buffer.alloc(buffer1.length + buffer2.length);
// 架构珠峰
// 目标buffer, 拷贝到buff的什么位置去  0，6拷贝的个数

// Buffer.prototype.copy = function (target, targetStart, sourceStart, sourceEnd) {
//     console.log('mycopy')
//     for (let i = sourceStart; i < sourceEnd; i++) {
//         target[targetStart + i] = this[i];
//     }
// }
// buffer1.copy(buff, 6, 0, 6);
// buffer2.copy(buff, 0, 0, 6);

Buffer.concat = function (bufferList, bufferLength = bufferList.reduce((a, b) => a + b.length, 0)) {
    let buff = Buffer.alloc(bufferLength);
    let offset = 0;
    bufferList.forEach(item => {
        item.copy(buff, offset, 0, item.length);
        offset += item.length
    });
    return buff;
}

let buffer = Buffer.concat([buffer1, buffer2], 1000)
// console.log(buffer.toString());

// **concat**  **length** **slice()**  **isBuffer**


// 实现buffer的分割操作

// let buff = Buffer.from('珠峰爱你爱你爱你');
// // buffer.indexOf(取索引)
// Buffer.prototype.split = function (sep) {
//     let len = Buffer.from(sep).length;
//     let offset = 0;
//     let arr = [];

//     let currentIndex = 0; // 当前找到的索引位置
//     while (-1 != (currentIndex = this.indexOf(sep, offset))) {
//         arr.push(this.slice(offset, currentIndex));
//         offset = currentIndex + len;
//     }
//     arr.push(this.slice(offset));
//     return arr;
// }

// console.log(buff.split('爱').toString());
// console.log(buff.indexOf('爱', 7)); // 字节索引


let fs = require('fs');
let r = fs.readFileSync('./aaaa.txt')

let iconv = require('iconv-lite')
let str = iconv.decode(r, 'gbk');
console.log(str);

// 这里utf-8 可以转化的


// 1.commonjs 规范的实现
// 2.buffer的基本操作
// 3.npm常用操作
// 4.自己实现10转36进制

// fs 流 http 

// node框架


// 数组的slice是浅拷贝
// let arr = [
//     [1, 2, 3]
// ];
// let newArr = arr.slice(0);
// newArr[0][0] = 1000;
// console.log(arr);