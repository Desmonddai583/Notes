// util是一个工具方法

// util.inherits()

// util.inspect()

//1. util.promisify()


let fs = require('fs');
let {promisify} = require('util');
let path = require('path');
let read = promisify(fs.readFile); // bluebird
read(path.join(__dirname,'./1.txt'),'utf8').then(function(data){
    console.log(data);
})
let util= require('util'); // dir用的就是inpsect方法
// util.inspect
console.log(util.inspect(Array.prototype,{showHidden:true}))


// util.inherits() 继承  只继承公有的方法
function A(){

}
A.prototype.fn = function(){
    console.log(1)
}
function B(){

}
util.inherits(A,B);
let b = new A();
b.fn();
// A.prototype.__proto = B.prototype;
// A.prototype = Object.create(B.prototype);
// Object.setPrototypeOf(A.prototype,B.prototype); √

// inherits只继承公有属性