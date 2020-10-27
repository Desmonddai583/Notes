// {'失恋':[findBoy,drink]}
// 监听的目的 就是为了构造这样一个对象 一对多的关系 on

// 发布的时候 会让数组的函数依次执行 emit
let EventEmitter = require('./events');
let util = require('util');
function Girl(){
   
}
util.inherits(Girl,EventEmitter);
let girl = new Girl(); 
let drink = function(data){
    console.log(data);
    console.log('喝酒');
}
let findBoy = function(){
    console.log('找男朋友');
}
// {'newListener':[fn]}
girl.on('newListener',function (eventName) {
})
girl.once('结婚',function(){

}) 
girl.setMaxListeners(3);
console.log(girl.getMaxListeners())
girl.once('失恋',drink) // {'失恋':[wrap.l]}
girl.once('失恋',drink) // {'失恋':[wrap.l]}
girl.once('失恋',drink) // {'失恋':[wrap.l]}
girl.once('失恋',drink) // {'失恋':[wrap.l]}
girl.prependOnceListener('失恋',function(){
    console.log('before')
}) // {'失恋':[wrap.l]}
girl.emit('失恋','1');
girl.emit('失恋','1');