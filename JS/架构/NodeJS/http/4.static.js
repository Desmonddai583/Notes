// 我希望用户通过浏览器 访问内容可以回显

const http = require('http');
const path = require('path');
const url = require('url');
const fs = require('fs');
const mime = require('mime'); 
let server = http.createServer((req,res)=>{
    let {pathname,query} = url.parse(req.url,true);
    const absPath = path.join(__dirname,pathname);

    // 我要先检测这个路径是不是目录 如果是目录默认查找index.html ,如果是文件直接返回
    fs.stat(absPath,function (err,statObj) {
        if(err){
            // 返回404； 找不到
            res.statusCode = 404;
            res.end('Not Found');
            return
        }
        if(statObj.isFile()){
            fs.readFile(absPath,function (err,data) {
                if(err){
                    res.statusCode = 404;
                    res.end('Not Found');
                    return
                }
                res.setHeader('Content-Type',mime.getType(absPath)+';charset=utf-8')
                res.end(data);
            })
        }else{
            // 先看是否有index.html 如果有我就返回
            fs.readFile(path.join(absPath,'index.html'),function (err,data) {
                if(err){
                    res.statusCode = 404;
                    res.end('Not Found');
                    return
                }
                res.setHeader('Content-Type','text/html;charset=utf-8')
                res.end(data);
            })
        }
    })
    // promise + async +await
});
server.listen(3000);