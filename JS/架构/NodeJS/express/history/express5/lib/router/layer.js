function Layer(path,handler){
    this.path = path;
    this.handler = handler
}
Layer.prototype.match = function (pathname) {
    if(this.path == pathname){ 
        return true; // 路由和中间件 和当前的请求路径一致肯定需要返回true
    }
    if(!this.route){
        // 中间件
        if(this.path == '/'){ 
            return true; // 只要中间件路径是/ 的话就需要执行
        }
        return pathname.startsWith(this.path+'/'); // 访问路径/user/a    中间件的路径/use
    }
    return false;
}
Layer.prototype.handle_error = function (err,req,res,next) {
    if(this.handler.length == 4){ // 在layer 内部会判断他是不是一个错误处理中间件
        this.handler(err,req,res,next);
    }else{
        next(err);
    }
}
Layer.prototype.handle_request = function (req,res,next) {
    // todo ...
    return this.handler(req,res,next);
}
module.exports = Layer
