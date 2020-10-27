const pathToRegExp = require('path-to-regexp');
function Layer(path,handler){
    this.path = path;
    this.handler = handler
    // 创建一个正则来使用
    this.regExp = pathToRegExp(path,this.keys = [],true);
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
    }else{
        // 如果是路由
        let matches = pathname.match(this.regExp);
        if(matches){
            let values = matches.slice(1);
            // 给layer 添加一个params属性
            this.params = values.reduce((memo,current,index)=>{
                memo[this.keys[index].name] = current;
                return memo
            },{});
            return true;  // 将这个params 放到 req.params上
        }
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