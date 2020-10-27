const http = require('http');
const httpProxy = require('http-proxy');

const proxy = httpProxy.createProxyServer();
http.createServer((req,res)=>{
    let host = req.headers.host;
    let obj = {
        'a.zf.cn':'http://localhost:3000',
        'b.zf.cn':'http://localhost:4000',
    }
    // 增加权限判断 过滤操作
    proxy.web(req,res,{
        headers:{
            a:1
        },
        target:obj[host]
    })
}).listen(80);
// nginx 配置不同的域名 跳到不同的项目
// webpack 我们访问服务器  代理服务器会拦截用户请求 -》转发给服务器