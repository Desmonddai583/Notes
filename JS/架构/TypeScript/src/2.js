"use strict";
/**
 * 函数
 */
function hello(name) {
    console.log('hello', name);
}
hello('zhufeng');
var getUserName = function (firstName, lastName) {
    return firstName + lastName;
};
//可选参数 必须是最后一个
function print(name, age) {
    console.log(name, age);
}
print('zhufeng');
print('zhufeng', 10);
//默认参数
function ajax(url, method) {
    if (method === void 0) { method = 'GET'; }
    console.log(url, method);
}
ajax('/users');
//剩余参数
function sum(prefix) {
    var numbers = [];
    for (var _i = 1; _i < arguments.length; _i++) {
        numbers[_i - 1] = arguments[_i];
    }
    return prefix + numbers.reduce(function (acc, curr) { return acc + curr; }, 0);
}
console.log(sum('$', 1, 2, 3));
//函数的重载
var obj = {};
function attr(val) {
    if (typeof val === 'string') {
        obj.name = val;
    }
    else if (typeof val === 'number') {
        obj.age = val;
    }
}
attr('zhufeng');
attr(10);
console.log(obj);
function sum2(a, b) {
}
sum2(1, 2);
sum2('a', 'b');
//No overload matches this call 没有为此调用找到匹配的重载
//sum2(1, 'b');
//=> 1.定义箭头的时候会用到=>  2. 定义函数类型的时候=>
