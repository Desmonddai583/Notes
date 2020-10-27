let fs = require('fs');
let uuid = require('uuid');
let path = require('path');
Buffer.prototype.split = function (sep) {
    let arr = [];
    let len = Buffer.from(sep).length;
    let current;
    let offset = 0;
    while((current = this.indexOf(sep,offset))!== -1){
        arr.push(this.slice(offset,current));
        offset = current + len;
    }
    arr.push(this.slice(offset));
    return arr;
}
const betterBody = ({uploadDir}={}) =>{
    return async (ctx,next)=>{
        // ctx.request.files
        // 获取用户传递来的请求体
        await new Promise((resolve,reject)=>{
            let arr =[];
            ctx.req.on('data',function (chunk) {
                arr.push(chunk);
            });
            ctx.req.on('end',function () {
                let allData = Buffer.concat(arr);
                let boundary = '--'+ctx.get('Content-Type').split('=')[1]
                let lines = allData.split(boundary).slice(1,-1);
                let obj = {}
                lines.forEach(line=>{
                    let [head,body] = line.split('\r\n\r\n');
                    head = head.toString();
                    console.log(head);
                    let key = head.match(/name="(.+?)"/)[1]
                    if(!head.includes('filename')){
                        obj[key] = body.toString().slice(0,-2);
                    }else{
                        let content = line.slice(head.length+4,-2);
                        let filePath = path.join(uploadDir,uuid.v4());
                        obj[key] = filePath;
                        fs.writeFileSync(filePath,content);
                    }
                })
                ctx.request.files = obj
                resolve();
            })
        });
        await next();
    }
}

module.exports = betterBody