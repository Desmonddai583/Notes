let fs = require('fs');
let path = require('path');
let EventEmitter = require('events');// 订阅  发布
let events = new EventEmitter();
let arr = [];
events.on('getData',function(d){ // 绑定的功能
    arr.push(d);
    if(arr.length === 2){
        console.log(arr);
    }
})
fs.readFile(path.join(__dirname,'1.txt'),'utf8',function(err,data){
    events.emit('getData',data)
})
fs.readFile(path.join(__dirname,'2.txt'),'utf8',function(err,data){
    events.emit('getData',data)
});
//  node中 http stream 都会继承这个模块

//Promise.all 高阶函数 after  / 发布订阅


let EventEmitter = require('events');
let util = require('util');
function Girl(){

}
util.inherits(Girl,EventEmitter);

let girl = new Girl();
// 当绑定新的事件时 会触发这个函数
// girl.on('newListener',function(eventName,callback){
//     console.log(eventName)
// });
function findnewBoy(data){
    console.log(data)
}
girl.once('失恋',findnewBoy);// on绑定的方法不会马上执行，只有当emit时才会执行
// once表示只绑定一次，触发一次，触发后不在触发

// 没发生之前可以移除监听
girl.removeListener('失恋',findnewBoy)

console.log(EventEmitter.defaultMaxListeners); // 默认情况下 默认能绑定10个方法，超过了会报内存泄漏异常

girl.setMaxListeners(3); // 最多能绑定三个 
console.log(girl.getMaxListeners())
girl.once('失恋',findnewBoy);
girl.once('失恋',findnewBoy);
girl.once('失恋',findnewBoy);
girl.once('失恋',findnewBoy);
console.log(girl.eventNames());
girl.prependOnceListener('失恋',function(){
    console.log('hello')
})
girl.emit('失恋','newBoy');
girl.emit('失恋','newBoy');