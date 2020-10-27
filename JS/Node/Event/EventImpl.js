function EventEmitter() {
    this._events = Object.create(null);
}
EventEmitter.defaultMaxListeners = 10;
EventEmitter.prototype.addListener = EventEmitter.prototype.on;
EventEmitter.prototype.setMaxListeners = function(n){
    this._count = n;
}
EventEmitter.prototype.getMaxListeners = function(){
    return this._count?this._count : EventEmitter.defaultMaxListeners
}
EventEmitter.prototype.eventNames = function(){
    return Object.keys(this._events)
}
EventEmitter.prototype.on = function(type,callback,flag){
    if(!this._events){
        this._events = Object.create(null);
    } // 默认值
    // 不是newListener 我就应该让newListener执行一下
    if(type !== 'newListener'){
        this._events['newListener']&& this._events['newListener'].forEach(listener=>{
            listener(type)
        })
    }

    if(this._events[type]){
        if(flag){
            this._events[type].unshift(callback);
        }else{
            this._events[type].push(callback);
        }
     
    }else{ //内部没存放过
        this._events[type] = [callback]
    }
    if(this._events[type].length === this.getMaxListeners()){
        console.warn('-------------------------------')
    }
}
EventEmitter.prototype.removeListener = function(type,callback){
    if(this._events[type]){
        // 返回false就表示不要了
        this._events[type] = this._events[type].filter(function(listener){
                return callback!=listener&&listener.l!==callback;
        });
    }
}
EventEmitter.prototype.prependListener = function(type,callback){
    this.on(type,callback,true)
}
EventEmitter.prototype.prependOnceListener = function(type,callback){
    this.once(type,callback,true)
}
EventEmitter.prototype.listeners = function(type){
    return this._events[type];
}
EventEmitter.prototype.once = function(type,callback,flag){
    // 先绑定 调用后再删除
    function wrap (){
        callback(...arguments);
        this.removeListener(type,wrap);
    }
    // 自定义属性
    wrap.l  = callback
    this.on(type,wrap,flag);
}
EventEmitter.prototype.removeAllListener = function(){
    this._events = Object.create(null);
}

EventEmitter.prototype.emit = function(type,...args){
    if(this._events[type]){
        this._events[type].forEach(listener => {
            listener.call(this,...args);
        });
    }
}
module.exports = EventEmitter