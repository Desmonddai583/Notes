// 三种buffer的声明方式 内存 大小是不能发生变化的
// buffer 可以通过数字 通过字符串来声明 可以通过数组来声明

let buffer = Buffer.alloc(10);
let buffer1 = Buffer.from('珠峰'); // utf8格式
let buffer2 = Buffer.from([0xe7, 0x8f, 0xa0]);
console.log(buffer, buffer1, buffer2);

// Buffer 可以和字符串任意的转化
console.log(buffer1.toString('base64')); // 6 8 大了3分之一
// 怎么转化base64 可以放到任何的url的地方 src上
// 不能转化大图片

// 编码的操作 汉字 1个汉字3个字节 24位（3*8）  (4*6格式)

let code = Buffer.from('珠');
console.log(0xe7.toString(2)); // e7 8f a0
console.log(0x8f.toString(2));
console.log(0xa0.toString(2));
// 0x16jinz
// 00111001   00111000   00111110   00100000
// 00111111 // 取值范围是0-63  base64

// 规范表 取值表

let str = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
str += 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.toLowerCase();
str += '0123456789+/';

console.log(parseInt('00111001', 2))
console.log(parseInt('00111000', 2))
console.log(parseInt('00111110', 2))
console.log(parseInt('00100000', 2))
console.log(str[57] + str[56] + str[62] + str[32]);

// 前端的二进制