const http = require('http');
const url = require('url');
const Router = require('./router/index');
// 提供一个应用类

// 将路由系统和我们的应用系统耦合在了一起
// 将应用和路由进行一个分离操作
function Application() { // 每次 let app = express() 都应该创建一个对应的路由系统
    this._router = new Router();
}
Application.prototype.get = function (path, ...handlers) {
    this._router.get(path, handlers);
}
Application.prototype.listen = function () {
    let server = http.createServer((req, res) => {
        // 需要让路由自己去自动匹配，如果你匹配不到你在找“应用系统”
        function done() {
            res.end(`Cannot ${req.method} ${req.url} my`)
        }
        this._router.handle(req, res, done)
    });
    server.listen(...arguments);
}
module.exports = Application;