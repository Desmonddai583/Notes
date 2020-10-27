let a = 'hello'
module.exports = 'xxx'
// module.exports = {}
// let exports = module.exports
// exports = 'hello'

// 引用类型的特点
// exports = 'xxx' 错误写法

// exports.a = 100;
// module.exports = '100';
// module.exports.a = 100;
// global.xxx 可以定义全局变量

this.a = 1;
this.b = 2;

// 下面的会覆盖掉上面的
module.exports = {
    a: 3,
    b: 4
}