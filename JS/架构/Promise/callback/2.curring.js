// 函数柯里化

// 判断一个变量的类型
// 判断类型 有四种方式 constructor instanceof typeof Object.prototype.toString.call
// function checkType(content,type){
//     return Object.prototype.toString.call(content) === `[object ${type}]`
// }
// let bool = checkType('hello','String');
// let bool1 = checkType('aa','String');
// 什么叫函数柯里化 把一个函数的范围进行缩小 让函数变的更具体一些
// function checkType(type){
//     // 私有化，这个函数 可以拿到上层函数的参数， 这个空间不会被释放掉
//     return function (content) {
//         // [object String]  [object Number]  [object Boolean]
//         return Object.prototype.toString.call(content) === `[object ${type}]`
//     }
// }
// let isString = checkType('String');
// let isBoolean = checkType('Boolean');
// let flag1 = isString('aaa');
// let flag2 = isBoolean(true);
// console.log(flag1,flag2);


// 通用的函数柯里化  我希望可以分开传递参数 
// function checkType(content, type) {
//     return Object.prototype.toString.call(content) === `[object ${type}]`
// }

// 如何实现通用的函数柯里化
const add = (a, b, c, d, e,f,g,h=10) => {
    return a + b + c + d + e + f + g+h
}
const curring = (fn,arr=[]) =>{
    let len = fn.length; // 长度指代的是函数的参数个数
    return (...args)=>{ // 保存用户传入的参数
        arr = [...arr,...args]
        if(arr.length < len){ // 通过传递的参数 不停的判断是否达到函数执行的参数个数
            return curring(fn,arr); // [1,2]
        }
        return fn(...arr); // 如果达到了执行个数之后 会让函数执行 
    }
}
// console.log(curring(add,[1,2])(3,4)(5)(6)(8)(10)) // 15
// 分批传递参数
function checkType(type,content) {
    return Object.prototype.toString.call(content) === `[object ${type}]`
}
let util = {};
['Number','String','Boolean'].forEach(item=>{
    // 相当于将函数 先调用依次 
    util['is'+item] = curring(checkType)(item)
})
let r = util.isString('hello');
let b = util.isBoolean(true)
console.log(r,b);

// 函数反柯里化 自己百度 是让一个函数的范围变大  
// Object.prototype.toString
// toString

