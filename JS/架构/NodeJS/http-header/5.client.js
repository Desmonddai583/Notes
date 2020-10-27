// 每次客户请求服务器 都返回部分内容


const http = require('http');
const fs = require('fs');
// 续传
let start = 0;
function download(){
    let end = start + 5
    http.get({
        host:'localhost',
        port:3000,
        method:'get',
        headers:{
            Range:`bytes=${start}-${end-1}`
        }
    },function (res) {
        // xxx-xxx/total 迅雷
        let total = res.headers['content-range'].split('/')[1];
        res.on('data',function (data) {
            fs.appendFileSync('2.txt',data);
            if(total > end){
                setTimeout(() => {
                    start += 5;
                    download();
                }, 1000);
            }
        })
    })
}
download();

