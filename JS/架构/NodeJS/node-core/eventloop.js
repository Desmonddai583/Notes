// node中实现的微任务 他的优先级比promise还要高
// nextTick 和 promise 是两个队列 所以会先清空nextTick队列
// process.nextTick(() => {
//     console.log(1)
//     process.nextTick(() => {
//         console.log(2)
//         process.nextTick(() => {
//             console.log(3)
//         })
//     })
// })
// Promise.resolve().then(() => {
//     console.log('promise')
// });
// node的事件环 在nodeV10版本之后 统一执行效果和浏览器一致
// 每个宏任务执行完毕都会清空微任务 

// × 老版本是每个队列清空后清空微任务

// 如果setImmediate 和setTimeout 在默认环境下执行会受性能影响
// setImmediate(() => { // 立即
//     console.log('setImmediate'); // node中的宏任务
// });
// setTimeout(() => {
//     console.log('setTimeout')
// }, 0);

let fs = require('fs');

fs.readFile('.gitignore', 'utf8', () => {
    setImmediate(() => { // 立即
        console.log('setImmediate1'); // node中的宏任务
    });
    setTimeout(() => {
        console.log('setTimeout5')
    }, 0);
    setImmediate(() => { // 立即
        console.log('setImmediate2'); // node中的宏任务
    });
    setImmediate(() => { // 立即
        console.log('setImmediate3'); // node中的宏任务
    });
    setImmediate(() => { // 立即
        console.log('setImmediate4'); // node中的宏任务
    });
})

// 默认当主代码执行完毕后会进入到事件环
// 1会先看当前定时器是否到达时间，如果到达时间会执行 定时器的回调
// 2.poll阶段会执行i/o操作的回调，如果没有i/o 看一下有没有setImmediate,如果有会进入到check阶段
// 3.如果没有 要检查是否有定时器如果没定时器也没有,i/o操作则结束循环
// 4.如果有定时器，定时器到达时间后 ，会返回timer阶段执行定时器的回调
// 5.每一个宏任务执行完毕后都会清空微任务


// Buffer 是node中为了实现二进制操作，提供的类
// clearInterval
// clearTimeout
// setImmediate

// setImmediate nextTick
setImmediate(() => {
    console.log('setImmediate1')
    process.nextTick(() => {
        Promise.resolve().then(() => {
            console.log('promise1')
        });
    })
})
setImmediate(() => {
    console.log('setImmediate2')
    Promise.resolve().then(() => {
        console.log('promise2')
    });
    process.nextTick(() => {
        console.log('nextTick2')
    })
})
process.nextTick(() => {
    console.log('nextTick1')
});

// n1 s1 p1 s2 n2 p2


// 宏任务和微任务进行分类

// Vue.nextTick 混合型任务 他可能是微任务也可能是宏任务
// 微任务 promise.then / mutationObserver / process.nextTick
// 宏任务 script标签 ui渲染  MessageChannel(浏览器) ajax event事件 setTimeout
// setImmediate requestFrameAnimation

// 浏览器是一个宏任务队列   node的话多个宏任务队列
// 执行顺序是一样的

// 模块的应用 怎么实现一个commonjs规范 npm的使用 版本 包的发布安装
// buffer arrayBuffer blob file typedView DataView 编码

// fs基础使用 流  http模块

// 直播尽量跟 课下 1.5倍速度 过一遍

// https://nodejs.org/zh-cn/docs/guides/event-loop-timers-and-nexttick/