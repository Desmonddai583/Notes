const http = require('http');
const path = require('path');
const fs = require('fs');
const url = require('url');
const whiteList = ['a.zf.cn:3000']
const server = http.createServer((req,res)=>{
    const {pathname} = url.parse(req.url,true);
    const absPath = path.join(__dirname,pathname);
    fs.stat(absPath,function (err,statObj) {
        if(err){
            res.statusCode = 404;
            res.end('Not Found');
            return
        }
        if(statObj.isFile()){
            // 只有别人引用这张图片才有referer 直接打开是没有referer
            if(/(\.png)|(\.jpg)/.test(absPath)){
                let referer = req.headers['referer'] ||  req.headers['referrer'];
                if(referer){ // 说明这个资源被引用了
                    let hostname = req.headers.host;
                    referer = url.parse(referer).host;
                    console.log(hostname,referer)
                    if(hostname !== referer && !whiteList.includes(referer)){
                        let errorFile = path.join(__dirname,'2.jpg')
                        fs.createReadStream(errorFile).pipe(res);
                        return
                    }
                }
            }
            fs.createReadStream(absPath).pipe(res);
        }else{
            res.statusCode = 404;
            res.end('Not Found');
        }
    })

}); 

server.listen(3000);