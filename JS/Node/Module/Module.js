// fs里面有一个新增 判断文件是否存在
let fs = require('fs'); // fs.readFile fs.readFileSync
fs.accessSync('./5.module/1.txt'); // 文件找到了就不会发生任何异常

// 解决路径问题
let path = require('path');
// resolve方法你可以给他一个文件名，他会按照当前运行的路径 给你拼出一个绝对路径
// __dirname 当前文件所在的文件的路径 他和cwd有区别
console.log(path.resolve(__dirname,'a')); // 解析绝对路径
console.log(path.join(__dirname,'a')); // join就是拼路径用的 可以传递多个参数
// 获取基本路径 
console.log(path.basename('a.js','.js')); // 经常用来 获取除了后缀的名字
console.log(path.extname('a.min.js')); // 获取文件的后缀名（最后一个.的内容）
console.log(path.posix.delimiter); // window下是分号  maclinux 是:
console.log(path.sep);  // window \  linux /

// vm 虚拟机 模块 runinThisContext
let vm = require('vm'); // eval是依赖于环境的

var a  = 1 ;
vm.runInThisContext(`console.log(a)`); //会报错


let path = require('path');
let fs = require('fs');
let vm = require('vm');
function Module(filename){ // 构造函数
    this.filename = filename;
    this.exports = {};
    this.loaded = true;
}
Module._extentions = ['.js','.json','.node']; // 如果没有后缀 希望添加上查找
Module._cache = {};
Module._resolvePathname = function(filename){
    let p = path.resolve(__dirname,filename);
    if(!path.extname(p)){
        for(var i = 0;i<Module._extentions.length;i++){
            let newPath = p + Module._extentions[i];
            try{ // 如果访问的文件不存在 就会发生异常
                fs.accessSync(newPath);
                return newPath
            }catch(e){}
        }
    }
    return p; //解析出来的就是一个绝对路径
}
Module.wrapper = [
    "(function(exports,require,module,__dirname,__filename){","\n})"
]
/*
    (function(exports,require,module,__dirname,__filename){
        this = module.exports;
        console.log('加载');
        module.exports = 'zfpx'; 
    })

*/
Module.wrap = function(script){
    return Module.wrapper[0]+script+Module.wrapper[1];
}
Module._extentions["js"] = function(module){ // {filename,exports={}}
    let script = fs.readFileSync(module.filename);
    let fnStr = Module.wrap(script);
    vm.runInThisContext(fnStr).call(module.exports,module.exports,req,module)
    // module.exports = zfpx
}
Module._extentions["json"] = function(module){
    let script = fs.readFileSync(module.filename);
    // 如果是json直接拿到内容  json.parse即可
    module.exports = JSON.parse(script); 
}
Module.prototype.load = function(filename){ //{filename:'c://xxxx',exports:'zfpx'}
    // 模块可能是json 也有可能是js
    let ext = path.extname(filename).slice(1); // .js   .json
    Module._extentions[ext](this);
}

function req(filename){ // filename是文件名 文件名可能没有后缀
    // 我们需要弄出一个绝对路径来，缓存是根据绝对路径来的
    filename = Module._resolvePathname(filename); 
    //console.log(filename);
    // 先看这个路径在缓存中有没有，如果有直接返回
    let cacheModule = Module._cache[filename];
    if(cacheModule){ // 缓存里有 直接把缓存中的exports属性进行返回
        return cacheModule.exports
    }
    // 没缓存 加载模块
    let module = new Module(filename);  // 创建模块 {filename:'绝对路径',exports:{}}
    module.load(filename); // 加载这个模块     {filename:'xxx',exports = 'zfpx'}
    Module._cache[filename] = module;
    module.loaded = true; // 表示当前模块是否加载完 
    return module.exports;
}
let result = req('./school');
console.log(result);


// exports = 1;  //Wrong!!!


// -------------
module.exports = 1;
exports.a = 1; // 相当于在exports对象上增加了一个属性

/*
    (function(exports,require,module,__dirname,__filename){
        this = module.exports;
        console.log('加载');
        module.exports = 'zfpx'; 
    })({},req,{filename,exports:{}})

*/