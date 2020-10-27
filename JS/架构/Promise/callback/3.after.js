// after 在... 之后
// 我希望我调用某个函数 3 次之后 再去执行
function after(times,say){ // 高阶函数
    return function () {
        if(--times == 0){
            say();
        }
    }
}
let newSay = after(3,function say() { // 保存一个变量 到after的内部
    console.log('say')
})
newSay();
newSay();
newSay();


// 异步并发问题！ 我同时发送多个请求  我希望拿到最终的结果 {name,age}