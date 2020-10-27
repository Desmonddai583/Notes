const Layer = require('./layer');
const methods = require('methods');
function Route() {
    this.stack = []; // 存的是用户的回调   数组结构  映射表
    this.methods = {} // 我这个route里 有哪些方法
}
methods.forEach(method=>{
    Route.prototype[method] = function (handlers) {
        handlers.forEach(handler => {
            let layer = new Layer('/', handler);
            layer.method = method;
            this.methods[method] = true; // {post:true,delete:true,get:true}
            this.stack.push(layer)
        });
    }
})

Route.prototype.handle_method = function (method) {
    return this.methods[method]
}

// 等会请求到来时会执行这个方法
Route.prototype.dispatch = function (req, res, out) {
    let idx = 0;
    let next = (err) => {
        if(err) return out(err);
        if (idx >= this.stack.length) return out();
        let layer = this.stack[idx++];
        // 匹配layer上新增的method属性 是否一致
        if (layer.method === req.method.toLowerCase()) {
            // 将向下执行的权限交给用户 执行第一个后调用next 会走第二层
            layer.handle_request(req, res, next)
        } else {
            next();
        }
    }
    next();
}
module.exports = Route;
// 路由的layer上有route (layer上是有路径的) route里面放的是用户传入的回调 通过回调产生一个个layer (没有路径的 有方法)
