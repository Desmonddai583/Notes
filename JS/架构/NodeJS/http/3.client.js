// 中间层 可以解决跨域问题
const http = require('http');
// 爬虫

let options = {
    port:3000,
    hostname:'localhost',
    pathname:'/?a=1',
    method:'post'
}
// get方法只能发送get请求
// request 请求
// super-agent

// axios request模块

let myServer = http.createServer((request,response)=>{
    // 前端发来了一个ajax   性别 男/女  0/1
    // 前端的ajax 
    // redis  中
    let client =  http.request(options,function (res) { // res 就是可读流
        let arr = [];
        res.on('data',function (chunk) { 
            arr.push(chunk);
        });
        res.on('end',function () { 
            response.end(Buffer.concat(arr).toString()+'world');
        });
    });

    // header http:协议 规则

    // req.write('hello')
    client.end('a=1'); // ajax.send
})
myServer.listen(3001);

