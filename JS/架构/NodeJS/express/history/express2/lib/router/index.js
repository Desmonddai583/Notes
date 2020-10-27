const url = require('url')

function Router() {
    this.stack = []; // 维护用户所有的路由
}

Router.prototype.get = function (path, handler) {
    this.stack.push({
        path,
        handler,
        method: 'get'
    })
}
Router.prototype.handle = function (req, res, done) {
    let {
        pathname
    } = url.parse(req.url);
    let m = req.method.toLowerCase();
    // 路由内部会匹配路由，如果无法匹配就让应用来处理
    for (let i = 0; i < this.stack.length; i++) {
        let {
            path,
            handler,
            method
        } = this.stack[i];
        if (path === pathname && method == m) {
            return handler(req, res);
        }
    }
    done();
}
module.exports = Router;