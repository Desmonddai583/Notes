// 中间层 可以解决跨域问题
const http = require('http');
// 爬虫

let options = {
    port: 3000,
    hostname: 'localhost',
    pathname: '/?a=1',
    method: 'post',
    headers:{
        // 'Content-Type':'application/x-www-form-urlencoded'
        'Content-Type':"application/json"
    }
}
let client = http.request(options, function (res) { // res 就是可读流
    let arr = [];
    res.on('data', function (chunk) {
        arr.push(chunk);
    });
    res.on('end', function () {
        console.log(Buffer.concat(arr).toString())
    });
});

client.end('{"name":"zf"}');

// header 就是http在tcp 的基础上增加了通信的规范，前后端可以通过这些特定的header进行交互