const Koa = require('koa');
const body = require('koa-bodyparser');
const path = require('path')
const Router = require('koa-router');
// const jwt = require('jwt-simple'); // jsonwebtoken

let jwt = {
    base64URLEscape(content) {
        return content.replace(/\+/g, '-').replace(/\//g, '_').replace(/=/g, '')
    },
    toBase64(content) {
        if(typeof content == 'object') {
            content = JSON.stringify(content);
        }
        return this.base64URLEscape(Buffer.from(content).toString('base64'));
    },
    sign(content, secret) {
        let r = require('crypto').createHmac('sha256', secret).update(content).digest('base64');
        return this.base64URLEscape(r);
    },
    encode(username, secret) {
        // 将head 转化成base64
        let header = this.toBase64({
            typ: 'JWT',
            alg: 'HS256'
        }); // 固定head
        // 将payload变成base64
        let payload = this.toBase64(username); // 明文 还是可以解码回来的 不要存敏感信息
        // 用header 和 payload 放在一起组成 一个签名
        let sign = this.sign([header, payload].join('.'), secret);
        // 三部分放在一起就是最终的结果
        return [header, payload, sign].join('.');
    },
    base64urlUnescape(str) {
        str += new Array(5 - str.length % 4).join('=');
        return str.replace(/\-/g, '+').replace(/_/g, '/');
    },
    decode(token) {
        let [header, payload, sign] = token.split('.');
        let newSign = this.sign([header, payload].join('.'), secret);
        if (sign == newSign) {
            return Buffer.from(this.base64urlUnescape(payload), 'base64').toString()
        } else {
            throw new Error('不对')
        }
    }
}

let app = new Koa();
let router = new Router();
app.use(body());
app.use(router.routes());
const secret = 'zf'
router.post('/login', async (ctx) => {
    let {
        username,
        password
    } = ctx.request.body;
    if (username == 'admin' && password == 'admin') {
        let token = jwt.encode(username, secret);
        ctx.body = {
            code: 0,
            username,
            token
            // head.payload.sign
            // "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.ImFkbWluIg.wKu3FR4hyvnoL4n6Smosm6_o5KbxGmgzqlMt7VtDeJU"
            //  eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.ImFkbWluIg.wKu3FR4hyvnoL4n6Smosm6_o5KbxGmgzqlMt7VtDeJU
        }
    }
})


router.get('/isLogin', async (ctx) => {
    // 默认用户会把token 放到Authorization 这个属性上
    let token = ctx.get('authorization');
    if (token) {
        try {
            let r = jwt.decode(token, secret)
            console.log(r)
            ctx.body = {
                code: 0,
                username: r
            }
        } catch(e) {
            console.log(e)
            ctx.body = {
                code: 1,
                data: '没有登录'
            }
        }
    } else {
        ctx.body = {
            code: 1,
            data: '没有登录'
        }
    }
})

app.listen(3000);