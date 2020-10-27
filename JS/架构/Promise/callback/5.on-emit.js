const fs = require('fs');
// 订阅 就是将要做的事情先存储好， 稍后发布的时候让订阅好的事情依次执行
// 观察者模式和发布订阅 之间有什么关系？
let e = {
    arr:[], // 发布订阅 他们两者之间没有联系
    on(fn){
        this.arr.push(fn);
    },
    emit(){
        this.arr.forEach(fn=>fn())
    }
}
e.on(()=>{
    console.log('读取到了数据')
})
let renderObj = {}
e.on(()=>{
    if(Object.keys(renderObj).length == 2){
        console.log('都读取完毕了')
    }
})
fs.readFile('./name.txt','utf8',function (err,data) {
    renderObj['name'] = data;
    e.emit(); // 触发 发射
})
fs.readFile('./age.txt','utf8',function (err,data) {
    renderObj['age'] = data;
    e.emit(); // 触发 发射
})
