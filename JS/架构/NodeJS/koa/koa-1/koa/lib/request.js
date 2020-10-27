const url = require('url');
let request = {
    get url() {
        // 这里的this 指代的是 ctx.request 因为使用的时候是通过 ctx.request.url来使用的
        // ctx.request.req = req
        return this.req.url;
    },
    get path() {
        return url.parse(this.req.url).pathname
    },
    get query() {
        return url.parse(this.req.url).query
    }
}
// 导出request对象
module.exports = request;


// 对象的属性访问器




