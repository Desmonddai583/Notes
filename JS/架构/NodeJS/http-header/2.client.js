const http = require('http');
const fs = require('fs');
http.get({
    hostname:'a.zf.cn',
    port:3000,
    path:'/1.jpg',
    headers:{
        referer:'b.zf1.cn'
    }
},function (res) {
    res.pipe(fs.createWriteStream('test.jpg'))
});


// superagent
// Puppeteer
