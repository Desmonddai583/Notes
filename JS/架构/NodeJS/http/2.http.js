const http = require('http');
const url = require('url');
// 请求 （请求行 请求头 请求体）
// 响应 （响应行 响应头 响应体）
let server = http.createServer((request,response)=>{
    // 请求行 相关信息
    let method = request.method.toLowerCase(); // 请求方法都是大写的 
    console.log(method);
    let {pathname,query} = url.parse(request.url,true); // 默认url 指从/ 到# 后面的内容
    console.log(pathname,query);
    let httpVersion = request.httpVersion;
    console.log(httpVersion);
    // 直接获取请求头的信息  （前部小写）
    console.log(request.headers['host']);

    // request是一个可读流 on('data') on('end')
    let arr = []; // tcp 分段传输
    request.on('data',function (chunk) { // data事件 只有传入数据时才触发
        arr.push(chunk);
    });
    // 可读流如果读取不到数据 内部会push(null)
    request.on('end',function () { // end 事件肯定会触发
        console.log(Buffer.concat(arr).toString());
    });

    // 响应
    // 响应行 状态码
    response.statusCode = 200; // 成功了  100 - 500
    // content-type 服务端返回给客户端的内容 需要加一个类型
    response.setHeader('Content-Type','text/plain;charset=utf-8');
    response.setHeader('a','1');
    // 响应体
    // response.write('hello')
    response.end('hello');
});


// 端口被占用可以自己累加
let port = 3000;
server.listen(port,()=>{
    console.log(`server start ` + 3000)
});
server.on('error',(err)=>{
    if(err.code === 'EADDRINUSE'){
        server.listen(++port)
    }
});