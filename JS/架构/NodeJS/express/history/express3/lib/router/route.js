const Layer = require('./layer');
function Route(){
    this.stack = [];
}
Route.prototype.get = function (handlers) {
    handlers.forEach(handler => {
        let layer = new Layer('/',handler);
        layer.method = 'get';
        this.stack.push(layer)
    });
}
// 等会请求到来时会执行这个方法
Route.prototype.dispatch = function () {
    
}
module.exports = Route;
// 路由的layer上有route (layer上是有路径的) route里面放的是用户传入的回调 通过回调产生一个个layer (没有路径的 有方法)