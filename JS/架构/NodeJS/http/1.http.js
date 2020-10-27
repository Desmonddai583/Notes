const http = require('http');
// 请求 （请求行 请求头 请求体）
// 响应 （响应行 响应头 响应体）

// 特定的ip 端口号来监听请求

// js 是单线程 node 也是单线程的
// todo ...
let server = http.createServer((request,response)=>{
    // if(request.url === '/sum'){
    //     let sum = 0;
    //     for(let i = 0; i < 1000000000; i++ ){
    //         sum+=i;
    //     }
    //     response.end(sum+'')
    // }else{
    //     response.end('ok');
    // }
});

// server.on('request',(request,response)=>{
//     console.log('请求到来时执行此方法2')
// });
/// 每次更改代码后需要重新启动服务


// npm install nodemon -g
// nodemon server.js
server.listen(3000,()=>{
    console.log('server start');
})