// 箭头函数(高阶函数 偏函数 函数柯里化)
// 箭头函数中没有function关键字,函数参数和函数体用箭头连在一起
// 如果参数只有一个 可以省略小括号
// 如果不写return 可以不写大括号(箭头后面就是返回值)
let a = function(b){
    return b
}
// 感觉没有变化（语法糖）没有arguments 没有this指向
let a = b => b
console.log(a('hello'));

// 什么是this，谁调用this就是谁,this和在哪定义无关 主要是看谁调用 和 执行环境有关
let age = 28;
let obj = {
    age:'18',
    fn:()=>{ // this = obj
        setTimeout(()=>{
            console.log(this.age)
        })
    }
}
 obj.fn();