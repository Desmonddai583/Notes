// 浏览器和node中解析的方式不一样  在浏览器中await 后面跟一个promise,那就直接then
// node中虽然你放的是一个promise 会在进行一次保证，node中await 后面的结果会被在包装一次
async function async1() {
    console.log('async1 start')
    //await async2() // 后面的内容会变成微任务,放到了then的回调中去
    // async2().then(() => {
    //     console.log('async1 end')
    // })
    // async2().then(resolve).then(() => {console.log('async1 end')})
    new Promise((resolve) => resolve(async2())).then(() => {
        console.log('async1 end')
    })
}
async function async2() {
    console.log('async2')
}
console.log('script start')
setTimeout(function () {
    console.log('setTimeout')
})
async1()
new Promise(function (resolve) {
    console.log('promise1')
    resolve()
}).then(function () {
    console.log('promise2')
})
console.log('script end')

// script start
// async1 start
// async2
// promise1
// script end
// async1 end
// promise2
// setTimeout

// 这周:主要讲node核心  周日 模块 npm buffer （arrayBuffer）
// 下周：文件操作 流  文件夹的操作 http模块
// 下下周：koa 的用法和原理 （cookie session jwt）express用法和原理
// 下下下周：node中进程 集群 pm2 mongo + redis

// node 是一个月一周