const http = require('http');
const querystring = require('querystring');
const crypto = require('crypto');
const uuid = require('uuid');
const secret = 'zf';

const cardName = 'cut';
const session = {}; // 服务器重启就丢失了 =》 redis数据库中

// cookie -> header
const sign = (value) => {
    // base64字符串再传输的过程 会把 /+= 变成 ' '
    return crypto.createHmac('sha256', 'secret').update(value + '').digest('base64').replace(/\/|\+|\=/, '')
}
let server = http.createServer((req, res) => {
    let arr = [];
    res.setCookie = function (key, value, options = {}) {
        let opts = [];
        if (options.domain) {
            opts.push(`domain=${options.domain}`)
        }
        if (options.path) {
            opts.push(`path=${options.path}`)
        }
        if (options.maxAge) {
            opts.push(`max-age=${options.maxAge}`)
        }
        if (options.expires) {
            opts.push(`expires=${options.expires.toGMTString()}`)
        }
        if (options.httpOnly) {
            opts.push(`httpOnly=${options.httpOnly}`)
        }
        if (options.signed) {
            value = value + '.' + sign(value); // 10.xxxx
        }
        arr.push(`${key}=${value}; ${opts.join('; ')}`);
        res.setHeader('Set-Cookie', arr);
    }
    req.getCookie = function (key, options = {}) {
        let cookieObj = querystring.parse(req.headers.cookie, '; ');
        if (options.signed) {
            let [value, s] = cookieObj[key].split('.');
            let newSign = sign(value);
            if (newSign === s) {
                return value;
            } else {
                return undefined;
            }
        }
        return cookieObj[key];
    }
    // 我希望做一个系统能记录
    if (req.url === '/cut') {
        let cardId = req.getCookie(cardName); // 拿到用户是否有卡
        if (cardId && session[cardId]) {
            session[cardId].mny -= 10;
            // 不需要重新创建卡
            res.end('current money is ' + session[cardId].mny);
        } else {
            let cardId = uuid.v4();
            session[cardId] = {
                mny: 100
            };
            res.setCookie(cardName, cardId,{httpOnly:true}); // 给xxx 发一个卡 
            res.end('current money is ' + session[cardId].mny + '; this times free')
        }
    }
});
// session 借助cookie 他是没有大小限制的 存在服务器中，服务器重启会丢失(持久化存储)
server.listen(3000);