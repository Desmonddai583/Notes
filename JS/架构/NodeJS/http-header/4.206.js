// 206 实现断点续传
// 上传 可以暂停

// 前端需要记录一个 上传的位置 （需要维护一个上传的位置）
// 206


// range:bytes=4-7 客户端的
// Content-Range: bytes 4-7/2381 文件总大小 


const http = require('http');
const path = require('path');
const fs = require('fs');
const url = require('url');
const whiteList = ['a.zf.cn:3000'];
const file = fs.statSync(path.resolve(__dirname, '1.txt'));
const pathUrl = path.resolve(__dirname, '1.txt')
const size = file.size;
const server = http.createServer((req, res) => {
    const {
        pathname
    } = url.parse(req.url, true);
    const range = req.headers['range'];
    if (range) {
        let matches = range.match(/(\d*)-(\d*)/);
        let [, start = 0, end] = matches
        end = end == '' ? size : end;
        res.statusCode = 206;
        res.setHeader('Content-Range', `bytes ${start}-${end}/${size}`);
        console.log(start, end, size)
        fs.createReadStream(pathUrl, {
            start: Number(start),
            end: Number(end)
        }).pipe(res)
    } else {
        fs.createReadStream(pathUrl).pipe(res)
    }
});
// 实现下载 
server.listen(3000);