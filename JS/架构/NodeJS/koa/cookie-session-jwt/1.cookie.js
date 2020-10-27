const http = require('http');
// cookie -> header

let server = http.createServer((req, res) => {
    if (req.url === '/write') {
        // key,value
        // domain 限制某个域可研访问
        // path 在哪个路径下可以访cookie /表示任何路径都ok   以路径开头即可
        // expires (绝对时间) /max-age (相对时间)
        // httpOnly 是否服务端设置后前端不能更改

        // 如果不设置 domain / path 每次请求都会带上cookie
        // 每次都会带上cookie 4k  存到客户端 不安全（篡改，被别人拦截）
        res.setHeader('Set-Cookie', ['name=zf; domain=.zf.cn; path=/; max-age=10', `age=10; httpOnly=true; expires=${new Date(Date.now() + 10*1000).toGMTString()}`])
        res.end('write ok');
    } else if (req.url === '/read') {
        res.end(req.headers.cookie || 'empty');
    } else if (req.url === '/write/read') {
        res.end(req.headers.cookie || 'empty');
    } else {
        res.end('not found');
    }
});


server.listen(3000);