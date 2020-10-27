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
methods.forEach(method => {
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

Router.prototype.use = function (path, handler) {
    if (typeof handler !== 'function') {
        handler = path; // 将path 赋值给handler
        path = '/'; // 做默认值处理
    }
    let layer = new Layer(path, handler);
    layer.route = undefined; // 表示中间件是不具备route属性的
    this.stack.push(layer);
}

Router.prototype.handle = function (req, res, out) {
    let {
        pathname
    } = url.parse(req.url);
    let m = req.method.toLowerCase();
    // 路由内部会匹配路由，如果无法匹配就让应用来处理

    // 依次取出来每一个来执行
    let idx = 0;
    let next = (err) => {
        if (idx >= this.stack.length) return out();
        let layer = this.stack[idx++];
        if (err) {
            // 找错误处理中间件
            if (!layer.route) {
                layer.handle_error(err, req, res, next)
            } else {
                next(err); // 如果是路由将错误继续向下传递
            }
        } else {
            // 如果是中间件 直接路径匹配就可以执行 如果要是路由 需要多匹配一个方法
            // 不管是路由还是中间件 路径都必须要进行匹配
            if (layer.match(pathname)) {
                if (!layer.route) { // 如果是正常的执行错误中间件是不会执行的
                    if (layer.handler.length !== 4) {
                        layer.handle_request(req, res, next); // 中间件
                    } else {
                        next(); // 如果是错误处理中间件 需要继续next向下执行
                    }
                } else {
                    // 路由需要匹配方法
                    if (layer.route.handle_method(req.method.toLowerCase())) {
                        layer.handle_request(req, res, next);
                    } else {
                        next();
                    }
                }
            } else {
                next();
            }
            // 外层需要判断路径是否一致 还有route中是否存放着对应的方法
            // if(layer.match(pathname) && layer.route.handle_method(req.method.toLowerCase())){ // 如果路径一样 就执行对应的处理函数
            //     layer.handle_request(req,res,next);
            // }else{
            //     next();
            // }
        }


    }
    next();
}
module.exports = Router;

// 讲中间件的实现 错误中间件 路由参数 参数的处理