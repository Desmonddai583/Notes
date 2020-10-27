const url = require('url')
const Route = require('./route'); // route的类
const Layer = require('./layer');
function Router() {
    this.stack = []; // 维护用户所有的路由
}
Router.prototype.route = function (path) {
    let route = new Route();
    // 每个路由的layer上 都有一个路径 和一个处理函数
    let layer = new Layer(path,route.dispatch.bind(route));
    layer.route = route;
    this.stack.push(layer); // 将当前生成的路由层 放到路由系统中
    return route;
}
Router.prototype.get = function (path, handlers) {

    //  当我们调用get 方法时 需要创建一个layer 将layer 放到我们的stack中
    //  路由系统中的layer上应该有一个route属性

    let route = this.route(path); // 每次调用get 我都产生一个route
    // 需要将 用户的handler 传入到当前路由对用的route的内部
    route.get(handlers);
    // this.stack.push({
    //     path,
    //     handler,
    //     method: 'get'
    // })
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