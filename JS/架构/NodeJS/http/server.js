const http = require('http');
const url = require('url');
const querystring = require('querystring');
// console.log(querystring.parse('a==1&&b==2&&c==3','&&','=='))
let server = http.createServer((request,response)=>{
    
    let arr = []; 
    request.on('data',function (chunk) { 
        arr.push(chunk);
    });
    // ajax 传递数据时 一般也是 a=1&b=2&c=3 查询字符串 /([^=&]+)=([^=&]+)/
    request.on('end',function () {
        let str = Buffer.concat(arr).toString();
        // 前后端通信 一般情况是通过json字符串格式
        if(request.headers['content-type'] == 'application/x-www-form-urlencoded'){
            response.end(JSON.stringify(querystring.parse(str)))
        }else if(request.headers['content-type'] === 'application/json'){
            let obj = JSON.parse(str);
            obj.d = 100;
            response.end(JSON.stringify(obj))
        }
        
    });
});

let port = 3000;
server.listen(port,()=>{
    console.log(`server start ` + 3000)
});
server.on('error',(err)=>{
    if(err.code === 'EADDRINUSE'){
        server.listen(++port)
    }
});
// 先用node 来实现一个静态服务
