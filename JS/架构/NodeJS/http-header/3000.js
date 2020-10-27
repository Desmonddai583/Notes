const http = require('http');

http.createServer((req,res)=>{
    res.end('3000' + req.headers.a)
}).listen(3000);