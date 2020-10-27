function EventEmitter() {
    this._events = {}
}
// {'女生失恋',[fn,fn]}
// 订阅
EventEmitter.prototype.on = function (eventName, callback) {
    if (!this._events) {
        this._events = Object.create(null);
    }
    if (eventName !== 'newListener') {
        // 如果当前绑定的不是newListener,看一下用户是否绑定过newListener,如果绑定过取出来依次执行
        if (this._events['newListener']) {
            this._events['newListener'].forEach(fn => fn(eventName))
        }
    }
    // 如果不存在这个事件 就绑定一个数组
    if (!this._events[eventName]) {
        this._events[eventName] = [callback]
    } else {
        // 如果存在将事件push进去
        this._events[eventName].push(callback);
    }
}
EventEmitter.prototype.emit = function (eventName, ...args) {
    // 触发对应的事件依次执行
    if (this._events[eventName]) {
        this._events[eventName].forEach(fn => {
            fn(...args);
        });
    }
}
// 删除监听的方法
EventEmitter.prototype.off = function (eventName, callback) {
    if (this._events && this._events[eventName]) {
        this._events[eventName] = this._events[eventName].filter(fn => {
            // 既不能函数相等 也不能这个函数的l 和 callback 是一样的
            return fn != callback && fn.l != callback
        });
    }
}
// click.once
EventEmitter.prototype.once = function (eventName, callback) {
    let one = (...args) => {
        callback(...args);
        this.off(eventName, one)
    }
    one.l = callback
    // 切片编程 绑定one 函数 在one函数中执行原有逻辑，并且执行完后再移除事件
    this.on(eventName, one);
}
module.exports = EventEmitter