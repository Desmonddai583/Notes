const url = require('url')
const Route = require('./route'); // route的类
const Layer = require('./layer');
const methods = require('methods');
function Router() {
    this.stack = []; // 维护用户所有的路由
}
Router.prototype.route = function (path) {
    let route = new Route();
    // 每个路由的layer上 都有一个路径 和一个处理函数
    let layer = new Layer(path, route.dispatch.bind(route));
    layer.route = route;
    this.stack.push(layer); // 将当前生成的路由层 放到路由系统中
    return route;
}
methods.forEach(method=>{
    Router.prototype[method] = function (path, handlers) {
        //  当我们调用get 方法时 需要创建一个layer 将layer 放到我们的stack中
        //  路由系统中的layer上应该有一个route属性
        let route = this.route(path); // 每次调用get 我都产生一个route
        // 需要将 用户的handler 传入到当前路由对用的route的内部
        route[method](handlers);
        // this.stack.push({
        //     path,
        //     handler,
        //     method: 'get'
        // })
    }
})

Router.prototype.handle = function (req, res, out) {
    let {
        pathname
    } = url.parse(req.url);
    let m = req.method.toLowerCase();
    // 路由内部会匹配路由，如果无法匹配就让应用来处理

    // 依次取出来每一个来执行
    let idx = 0;
    let next = () => {
        if(idx>=this.stack.length) return out();
        let layer = this.stack[idx++];
        // 外层需要判断路径是否一致 还有route中是否存放着对应的方法
        if(layer.match(pathname) && layer.route.handle_method(req.method.toLowerCase())){ // 如果路径一样 就执行对应的处理函数
            layer.handle_request(req,res,next);
        }else{
            next();
        }
    }
    next();
}
module.exports = Router;

// 讲中间件的实现 错误中间件 路由参数 参数的处理