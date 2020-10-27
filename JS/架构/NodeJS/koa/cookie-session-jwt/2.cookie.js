const http = require('http');
const querystring = require('querystring');
const crypto = require('crypto');
const secret = 'zf'
// cookie -> header
const sign = (value)=>{
    // base64字符串再传输的过程 会把 /+= 变成 ' '
    return crypto.createHmac('sha256',secret).update(value+'').digest('base64').replace(/\/|\+|\=/,'')
}
let server = http.createServer((req, res) => {
    let arr = [];
    res.setCookie = function (key,value,options={}) {
        let opts = [];
        if(options.domain){
            opts.push(`domain=${options.domain}`)
        }
        if(options.path){
            opts.push(`path=${options.path}`)
        }
        if(options.maxAge){
            opts.push(`max-age=${options.maxAge}`)
        }
        if(options.expires){
            opts.push(`expires=${options.expires.toGMTString()}`)
        }
        if(options.httpOnly){
            opts.push(`httpOnly=${options.httpOnly}`)
        }
        if(options.signed){
            value = value + '.' + sign(value); // 10.xxxx
        }
        arr.push(`${key}=${value}; ${opts.join('; ')}`);
        res.setHeader('Set-Cookie',arr);
    }
    req.getCookie = function (key,options={}) {
        let cookieObj =  querystring.parse(req.headers.cookie,'; ');
        if(options.signed){
            let [value,s] = cookieObj[key].split('.');
            let newSign = sign(value);
            if(newSign === s){
                return value;
            }else{
                return undefined;
            }
        }
        return cookieObj[key];
    }
    if (req.url === '/write') {
        // res.setHeader('Set-Cookie', ['name=zf; domain=.zf.cn; path=/; max-age=10', `age=10; httpOnly=true; expires=${new Date(Date.now() + 10*1000).toGMTString()}`])
        // res.end('write ok');
        res.setCookie('name', 'zf', {
            domain: '.zf.cn',
            path: '/',
            maxAge: 10,
        });
        res.setCookie('age', 10, {
            httpOnly: true,
            // expires: new Date(Date.now() + 10 * 1000)
            signed:true // 增加一个签名  age=10  加盐算法 
        });
        res.end('write ok');
    } else if (req.url === '/read') {
        // 读取出来的可以是某个字段的结果  aa=123; bb=456; xxx=123

        // 在获取cookie的时候 要做一个检测 如果cookie被人改了 就不要了
        res.end(req.getCookie('age',{signed:true}) || 'empty');
    }else {
        res.end('not found');
    }
});
server.listen(3000);