// fs模块包含着 文件操作的api 同时也包含了 文件夹操作的api

const fs = require('fs');
const path = require('path');
// 创建目录 必须要先有父级 再有子级
// fs.mkdirSync('a/b/c/d/e/f');

// function mkdirSync(path) {
//     let arr = path.split('/');
//     for (let i = 0; i < arr.length; i++) {
//         let p = arr.slice(0, i + 1).join('/');
//         // fs.exitsSync  -> exists =>cb(boolean) 
//         try {
//             fs.accessSync(p)
//         } catch {
//             fs.mkdirSync(p);
//         }
//     }
// }
// mkdirSync('a/b/c/d/e/f/g');

// function mkdir(path, callback) {
//     let arr = path.split('/');
//     // co库 递归的创建 next 方法

//     let index = 0;

//     function next() {
//         // 递归要有终止条件
//         if (index === arr.length) return callback();
//         let p = arr.slice(0, index + 1).join('/');
//         fs.access(p, (err) => {
//             index++;
//             if (err) { // 如果不存在则 创建
//                 fs.mkdir(p, next)
//             } else { // 存在直接跳过创建过程
//                 next()
//             }
//         })

//     }
//     next();
// }

// mkdir('e/e/e/e/ea/w', () => {
//     console.log('成功')
// })


// 删除目录
// 深度遍历 同步
// function rmdirDeepSync(p) {
//     let statObj = fs.statSync(p);
//     if (statObj.isDirectory()) {
//         let dirs = fs.readdirSync(p);
//         dirs.forEach(dir => {
//             let current = path.join(p, dir);
//             rmdirSync(current); // 递归删除目录
//         });
//         fs.rmdirSync(p);
//     } else {
//         fs.unlinkSync(p); // 如果是文件删除跑路即可
//     }
// }
// rmdirDeepSync('e');

// 这个逻辑使用异步怎么实现？
// 1) 异步串行执行 整个将节点串在一起
// 2) 异步并行执行 两个节点同时开始遍历 Promise.all


// 广度遍历
function wideSync(p) {
    let arr = [p];
    let index = 0;
    let current; // 获取当前指针指向谁
    while (current = arr[index++]) {
        let statObj = fs.statSync(current);
        if (statObj.isDirectory()) {
            let dirs = fs.readdirSync(current);
            dirs = dirs.map(d => path.join(current, d));
            arr = [...arr, ...dirs]
        }
    }
    for (let i = arr.length - 1; i >= 0; i--) {
        let current = arr[i];
        let statObj = fs.statSync(current);
        if (statObj.isDirectory()) {
            fs.rmdirSync(current);
        } else {
            fs.unlinkSync(current);
        }
    }
}
wideSync('a');
// 这个逻辑使用异步怎么实现？
// 1) 异步串行执行 整个将节点串在一起
// 2) 异步并行执行 两个节点同时开始遍历 Promise.all
// 3) 异步广度删除如何实现
// 算法？

// 作业： 周五 可读 流
// 可写流 + 链表


// 先删除儿子 在删除父亲 （readdirSync,rmdirSync,unlinkSync，statSync）
// let dirs = fs.readdirSync(p);
// dirs = dirs.map(dir => path.join(p, dir));
// dirs.forEach(dir => {
//     let statObj = fs.statSync(dir); // 判断状态
//     if (statObj.isDirectory()) { // 删除目录
//         fs.rmdirSync(dir)
//     } else {
//         fs.unlinkSync(dir) // 删除文件
//     }
// })
// fs.rmdirSync(p);