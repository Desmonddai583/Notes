// 1.直接比对文件的内容 （不是直接把文件传递给客户端，客户端带过来对比）

// 2. 可以通过摘要算法来实现计算 一个唯一的hash戳 

// 3. 摘要算法不是加密算法  只能通过输入推断出输出，不能通过输出反推内容

// 4.雪崩 如果内容一旦变化 输出的结果是翻天覆地的变化 
 
let crypto = require('crypto'); // 各种算法 包含 md5 sha1 sha256

let r = crypto.createHash('md5').update('hello1').digest('base64');
console.log(r)
// 只能通过暴力比对的方式来反解


