const http = require('http');
const path = require('path');
const fs = require('fs');
const url = require('url');

let languages = {
    en: {
        message: {
            hello: 'hello world'
        }
    },
    ja: {
        message: {
            hello: 'こんにちは、世界'
        }
    },
    "zh-CN": {
        message: {
            hello: '你好'
        }
    }
}
const server = http.createServer((req, res) => {
    const {
        pathname
    } = url.parse(req.url, true);
    const absPath = path.join(__dirname, pathname);
    // 如果访问服务器 我需要根据header 返回不同的内容
    // Accept-Language: ja,en;q=0.8,zh;q=0.9   [{name:'ja',q:1},{name:'zh-CN1',q:1},{name:'zh-CN1',q:1}]
    let lans = req.headers['accept-language'];
    if(lans){
        let r = lans.split(',').map(lan=>{
            let [name,q] = lan.split(';');
            let obj = {}
            obj.name = name;
            if(!q){
                q = 'q=1';
            }
            obj.q = q.split('=')[1];
            return obj;
        }).sort((a,b)=>b.q - a.q);
        res.setHeader('Content-Type','text/plain;charset=utf-8')
        for(let i = 0; i < r.length;i++){
            let lan = languages[r[i].name];
            if(lan && lan.message){
                return res.end(lan.message.hello);
            }
        }
    }
    return res.end('not has language');
});
server.listen(3000);