const http = require('http');
const response = require('./response');
const request = require('./request');
const context = require('./context');
const EventEmitter = require('events')
// 多个人 通过同一个类 实例化不同对象
module.exports = class Application extends EventEmitter {
    constructor(){
        super();
        // 默认先将response  request context 进行拷贝
        this.response = Object.create(response);
        this.request = Object.create(request);
        this.context = Object.create(context); // this.context.__proto__ = context

        this.middlewares = []; // 存放所有的use方法
    }
    use(callback){
        this.middlewares.push(callback); // [fn,fn,fn]
    }
    createContext(req,res){
        // 每次请求上下文 都应该是独立的
        let response = Object.create(this.response);
        let request = Object.create(this.request);
        let context = Object.create(this.context);  
        // 处理
        context.request = request;
        context.req = context.request.req= req;  // context.__proto__.__proto__ 

        context.response = response;
        context.res =  context.response.res = res;

        context.response.req = req;
        context.request.res = res;
        // context 和外卖的context 没关系 
        return context;
    }
    compose(ctx){
        // 默认将middlewares 里的第一个执行
        let index = -1; // 默认一次都每调用
        const dispatch = (i)=>{
            let middleware = this.middlewares[i];
            // 第一次调用将值保存到了index中
            if (i ==index){
                return Promise.reject(new Error('next() called multiple times my ----'))
            }
            index = i; // 相当于第一次调用时 我把index 变成0
            // 如果执行完毕后 有可能返回的不是promise
            if(i === this.middlewares.length){
                return Promise.resolve();
            }
            // 链式等待 默认先执行第一个 之后如果用户调用了await next()
            try{ // 这里需要增加try/catch 否则直接抛错 需要补货异常
                return Promise.resolve(middleware(ctx,()=>dispatch(i+1)));
            }catch(e){
                return Promise.reject(e);
            }
        }
        return dispatch(0); // 默认取出第一个执行
    }
    handleRequest(req,res){
        // this
        // 通过请求和响应 + 自己封装的request和response 组成一个当前请求的上下文 
        let ctx = this.createContext(req,res);   

        // 组合多个函数
        this.compose(ctx).then(()=>{
            res.end(ctx.body); // 最终拿到用户设置的结果 将结果返回即可
        }).catch(err=>{
            this.emit('error',err);
        })
    }
    listen(...args){
        // 通过bind 绑定这个方法,可以在构造函数中绑定
        // 箭头函数的方式改变this
        const server = http.createServer(this.handleRequest.bind(this));
        server.listen(...args);
    }
}

