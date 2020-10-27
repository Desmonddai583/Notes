// fs path vm
// fs fileSystem 文件系统 可以帮我们操作文件 目录....
// path 操作路径的 
// vm 做你一个虚拟运行环境


const fs = require('fs'); //  模块中api一般包含同步和异步的api
const path = require('path');
// readFileSync  同步api
// 读取文件全部采用绝对路径

// let flag = fs.existsSync(path.resolve(__dirname, '../.gitignore'));
// if (flag) {
//     let r = fs.readFileSync(path.resolve(__dirname, '../.gitignore'), 'utf8');
//     console.log(r)
// }

// 如果需要拼接/ 必须采用join resolve会回到根目录下
let r = path.join(__dirname, 'a', 'b', 'c', '/'); // 拼接  join 可以拼接/
let r1 = path.resolve(__dirname, 'a', 'b', 'c', '/') // 解析出绝对路径
let ext = path.extname('a.min.js');
let basename = path.basename('a.min.js', '.js');
console.log(ext, basename);


let vm = require('vm'); // eval new Function
// 如何让一个字符串执行？

// new Function 如果在前端中需要让一个模块执行

// 模块之间要相互独立 不希望模块之间的变量共享
// let a = 1000000;
// let fn = new Function('a', 'b', 'c', `console.log(a); return 100;`); // 可以让字符串变成函数
// console.log(fn(1, 2, 3))

// 直接运行字符串，运行函数字符串
vm.runInThisContext('console.log(a)');