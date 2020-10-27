// 事件模块 events 发布订阅 订阅（多个） 发布（触发n次）
// 核心模块  默认先看是不是核心模块
let EventEmitter = require('./events');
let util = require('util'); // promisify
// let events = new EventEmitter();
// class Girl extends EventEmitter{}
function Girl(){

}
// Girl.prototype.__proto__ = EventEmitter.prototype;
// Girl.prototype = Object.create(EventEmitter.prototype);
// Object.setPrototypeOf(Girl.prototype,EventEmitter.prototype)
// Object.setPrototypeOf(Girl.prototype,EventEmitter.prototype)
util.inherits(Girl,EventEmitter); // 继承原型上的属性或者方法
let girl = new Girl()
let cry  = (who)=>{
    console.log('哭'+who)
}
girl.once('女生失恋',cry)
let eat = (who)=>{
    console.log('吃'+who)
}
girl.once('女生失恋',eat);
girl.off('女生失恋',cry);
girl.off('女生失恋',eat);
girl.emit('女生失恋','我');

girl.emit('女生失恋','我');
girl.emit('女生失恋','我');
// off on emit once

// 第三方模块 (包)
// 查找策略是 默认查找node_modules文件，找同名的文件夹，默认找的是index.js 以main为入口
// 如果当前目录下 没有node_modules 会像上级查找，一直找到根目录 找不到则报错
// let r = require('a')
// console.log(module.paths)

// 尽量不要文件和文件夹的名字一置
// 文件查找方式 (会先找文件 先去添加.js .json 如果找不到)
// let r = require('./a')
// console.log(r)