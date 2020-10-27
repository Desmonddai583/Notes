// 命令行调试 
// 执行脚本时 增加一个 inspect参数  100%不会用
// node inspect 文件名

// 浏览器调试 
// 可以将node代码 当成浏览器代码调试
// node --inspect-brk 文件名

// 编辑器调试
function sum(a, b) {
    return a + b;
}
var a = 1;
var b = 2;
var a = 100;
console.log(sum(a, b));