// 在浏览器端 全局作用域window访问

// 我们可以直接在node中访问global

// node在执行的时候 为了实现模块增加了一个闭包
var a = 1;
console.log(global.a);

//1.console 标准输出
console.log('log');
console.info('info');
// 错误输出
console.warn('warn');
console.error('error');
// 标准输出 是1表示  错误输出是2表示

// 默认有些属性是隐藏属性
console.dir(Array.prototype,{showHidden:true});

// time 和 timeEnd中的内容是一对 名字相同，相同时才能打印出两段时间的间隔
console.time('label');
for(var i = 0;i<1000;i++){
}
console.timeEnd('label');

// 栈 指的就是代码的调用栈 先进后出 函数调用
console.log(1);
console.log(2);
function one(){
    var a =1;
    console.log(a);
    two();
    function two(){
        var b = 2;
        console.log(b)
        three();
        function three(){
            console.log(5);
            //console.trace();
        }
    }
}
one();


// 断言  会抛出一个AccertException,测试 mocha kamra
// chai TDD BDD DDD 持续继承  测试覆盖率
// node也提供了一个模块 asset
//console.assert((1+3)===2,'error');