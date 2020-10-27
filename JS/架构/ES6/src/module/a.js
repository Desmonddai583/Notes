let a = 1; // 表示我要把a导出  
let b = 2;
let c = 3;



export { // 导出的是变量 不是具体的值
    a,
    b,
    c
}

// 默认导出 直接导出某个变量 ，外层引入的时候 可以直接获取到
// export default 
// let obj = {a:1,b:2}
// export {
//     obj as default // 使用as 重命名 为default后 等价于 export default 
// }
let q = 100
export default q; // 只是导出变量对应的值
setInterval(() => {
    a++;
    q++;
}, 1000);
// export 和 export default的区别
// 不能多次 默认导出