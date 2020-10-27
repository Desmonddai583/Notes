// 全局变量就是可以直接访问的变量
// 如果定义在global上的属性 肯定是一个全局变量


// node里面默认在文件中打印this的问题 

// 在文件执行的过程中默认 这个文件会被加一层函数

// 通过函数的参数进行传入我们在文件中可以直接访问
// exports require module __filename __direname
console.log(__filename); // 代码当前的这个文件 绝对路径
console.log(__dirname, process.cwd())
// __dirname 代表的是当前文件运行的文件夹
// process.cwd() 代表的是当前工作目录 是可以更改的


//  exports require module node中模块化会使用到这三个属性
// 模块化 1.可以帮我们解决命名冲突的问题 (每个文件外面都会包装一个函数)  2.高内聚低耦合

// node的规范 commonjs规范 1.每个js文件都是一个模块 2.模块的导出 module.exports  3.模块的导入require
// esModule es6模块规范 import export  cmd seajs amd requirejs   umd模块 统一模块规范 

// commonjs规范 和 es6模块规范 区别 node中默认不支持es6模块
// commonjs规范动态引入 import 静态引入

// node中的模块化实现 == webpack模块的实现 （node中的模块如何进行加载的）

// 目前开发 你希望在node中使用import export babel-node


// node 中的模块可以分为三类 
// 1.核心模块/内置模块 fs http path 不需要安装 引入的时候不需要增加相对路径、绝对路径
// 2.第三方模块 require('co') 需要安装，别人写的
// 3.自定义模块 需要通过绝对路径或者相对路径进行引入