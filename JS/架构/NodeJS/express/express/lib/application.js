const http = require('http');
const url = require('url');
const Router = require('./router/index');
const methods = require('methods');
// 提供一个应用类

// 将路由系统和我们的应用系统耦合在了一起
// 将应用和路由进行一个分离操作
function Application() { // 每次 let app = express() 都应该创建一个对应的路由系统

    // 我希望 当创建应用时 不是立即初始化路由系统
    // this._router = new Router();
}
Application.prototype.lazy_route = function () {
    if(!this._router){ // 什么时候用到路由 什么时候进行加载
        this._router = new Router();
    }
}
methods.forEach(method=>{
    Application.prototype[method] = function (path, ...handlers) {
        this.lazy_route();
        this._router[method](path, handlers);
    }
})
// path可能没传 没传就是/
Application.prototype.use = function (path,handler) {
    // 应用层主要是分配逻辑的
    this.lazy_route();
    this._router.use(path,handler)
   
}
Application.prototype.param = function (key,handler) {
    // 交给路由来处理 在路由执行之前执行的
    this.lazy_route();
    this._router.param(key,handler);
}

Application.prototype.listen = function () {
    let server = http.createServer((req, res) => {
        this.lazy_route(); // 使用到路由系统时在去加载
        // 需要让路由自己去自动匹配，如果你匹配不到你在找“应用系统”
        function done() {
            res.end(`Cannot ${req.method} ${req.url} my`)
        }
        this._router.handle(req, res, done)
    });
    server.listen(...arguments);
}
module.exports = Application;