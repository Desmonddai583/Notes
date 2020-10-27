let EventEmitter = require('events');
let e = new EventEmitter();
// 会先绑定一个newListener 的事件
e.on('newListener', (type) => { // 此时这个回调没有被放进去
    process.nextTick(() => {
        e.emit(type)
    })
});
e.once('睡觉', () => {
    console.log('睡觉')
});

e.once('睡觉', () => {
    console.log('睡觉')
});

e.once('睡觉', () => {
    console.log('睡觉')
});
e.once('睡觉', () => {
    console.log('睡觉')
});
// on emit once off newListener