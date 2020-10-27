// node中可以采用同步的方式读取文件
// 异步的代码需要通过回调函数来解决
// let a = require('./a.js');
// console.log(a)

// 调试node代码 和浏览器调试方式基本一样
// 1.通过浏览器中调试node代码 可能调试一些包使用
// 2.vscode 进行代码调试 调试自己写的文件
// 3.在命令行中调试...·


// 通过读取文件内容 将内容包装到一个自执行函数中，默认返回module.exports做为函数的结果
// let a = `function (exports, require, module, __filename, __dirname) {
//     let a = 1
//     module.exports = 'hello';
//     return module.exports;
// }(exports, require, module, xxxx, xxx)`
const fs = require('fs');
const path = require('path');
const vm = require('vm');

function Module(id) {
    this.id = id;
    this.exports = {}; // 代表的是模块的返回结果
}
Module.wrapper = [
    `(function(exports,require,module,__filename,__dirname){`,
    `})`
]
Module._extensions = {
    '.js'(module) {
        let content = fs.readFileSync(module.id, 'utf8');
        content = Module.wrapper[0] + content + Module.wrapper[1];
        // 需要让函数字符串变成真正的函数
        let fn = vm.runInThisContext(content);
        let exports = module.exports; // {}
        let dirname = path.dirname(module.id);
        // 让包装的函数执行 require 时会让包装的函数执行，并且把this改变
        fn.call(exports, exports, req, module, module.id, dirname);
    },
    '.json'(module) {
        let content = fs.readFileSync(module.id, 'utf8');
        module.exports = JSON.parse(content);
    }
}
Module._resolveFilename = function (filename) {
    let absPath = path.resolve(__dirname, filename);
    // 查看路径是否存在 如果不存在 则增加 .js 或者.json后缀
    let isExists = fs.existsSync(absPath);
    if (isExists) {
        return absPath;
    } else {
        let keys = Object.keys(Module._extensions);
        for (let i = 0; i < keys.length; i++) {
            let newPath = absPath + keys[i];
            let flag = fs.existsSync(newPath);
            if (flag) {
                return newPath;
            }
        }
        throw new Error('module not exists');
    }
}
Module.prototype.load = function () {
    let extname = path.extname(this.id);
    Module._extensions[extname](this); // module.exports = 'hello'
}
Module._cache = {};

function req(filename) { // 默认传入的文件名可能没有增加后缀，如果没有后缀我就尝试增加.js .json
    // 解析出绝对路径
    filename = Module._resolveFilename(filename);
    // 创建一个模块
    // 这里加载前先看一眼 是否加载过了
    let cacheModule = Module._cache[filename]; //  多次引用同一个模块只运行一次
    if (cacheModule) {
        return cacheModule.exports; // 返回缓存的结果即可
    }
    let module = new Module(filename);
    Module._cache[filename] = module
    // 加载模块
    module.load();
    return module.exports;
}
let a = require('./a');
a.a = 1000;
let c = require('./a'); // (缓存的对象和原来对象的是同一个)
console.log(a, c); // exports 和 module.exports的关系 exports = module.exports = {}
// 运行步骤
// 1.Module._load 加载a模块
// 2. Module._resolveFilename 把相对路径转换成绝对路径
// 3.let module = new Module创建一个模块  模块的信息 id exports
// 4.tryModuleLoad 尝试加载这个模块
// 5.通过不同的后缀进行加载 .json / .js /
// 6. Module._extensions 文件的处理方式
// 7.核心就是读取文件  (exports 和module.exports)
// 8.给文件外层增加一个函数 并且让函数执行 （改变了this，exports,module,require,xx,xx）
// 9. 用户会给 module.exports 赋值
// 10.最终返回的是module.exports