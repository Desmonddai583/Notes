// ES6中的模块化问题  
// 什么叫模块 只要是一个js文件他就是一个模块  / webpack 图片 css模块
// 模块化解决的问题：命名冲突 (命名空间) 采用自执行函数的方式 解决代码的高内聚低耦合问题
// node中自带的模块化功能 require module.exports commonjs规范
// cmd seajs  amd requirejs
// umd 统一模块

// 如果我希望使用一个模块 require, 如果希望给别人用 module.exports
// node 模块 commonjs规范   es6模块规范 esModule umd
// es6模块如果希望给别人用 export 如果你希望用别人 就使用import

// es6 => node规范 webpack环境下可以通用

// 如果通过相对路径引入 表示是自定义模块
// 1) import的特点 可以变量提升 在没定以前可以直接使用 
// 2) 不能放到作用域下 ,只能放到顶层环境
// import {a,b,c} from './a.js'; // 从导出的对象中一个个取出  这种方式只能一个个取出来
// import * as obj from './a.js'; // 把所有导出的内容 放到obj对象中 把导出的所有结果都放到一个变量中

// 这个obj 必须采用export default 才可以拿到
// import obj,{a,b,c} from './a'

// 重命名可以使用as语法
import obj,{a,b,c,default as d} from './a'
setInterval(() => { // 每次拿到是这个变量对应的值,如果这个值变了那么结果会更新
    console.log(obj,d,a,b,c);
}, 1000);

// export 导出是接口、变量
// export default 导出是一个具体的内容
// 导入的变量不能修改


import * as z from './z';
console.log(z);


// 默认import 语法叫静态语法  动态加载 

// 草案中提供了一个语法  import() 可以实现懒加载

let btn = document.createElement('button');

btn.addEventListener('click',async function () {
    let result = await import('./a'); // 动态导入a这个文件 返回的是一个promise
    console.log(result); // 动态加载文件
});
document.body.appendChild(btn);

// 模块中的语法 import / export / export default/  export xx from  '' / import()

// 草案不属于es6
// stage-0 最初 买车 买钻戒 买房
// stage-1 买车 买钻戒
// stage-2 买钻戒  都被废弃 babel/preset-env
// stage-3