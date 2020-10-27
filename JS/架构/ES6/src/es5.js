// 默认以index.js 为入口
// 类  没有es6之前 用的都是构造函数来充当类
// vue的内容没有使用类 
// class的缺陷 所有的功能和方法都要放到类的内部 类只能通过类来调用

// 先来看下 es3 中构造函数的使用

// 类： 类实例中的属性  类中的公共方法  类中的继承  类中属性访问器  类中的静态方法 

// 1) 类中的this问题 指向的都是产生的实例
// 2) 如果返回了一个对象类型或函数类型 那么这个返回值会作为 实例

// 3) 抽象类 但是自己不能new
// function Animal(){ // 构造函数 -> 充当一个类
//     // if(!(this instanceof Animal)){
//     //     throw new Error('not new');
//     // }
//     // // 谁new我 target指向谁
//     // if(new.target === Animal){ // 我直接new的Animal类
//     //     throw new Error('这是一个抽象类 不能被new')
//     // }
// }
 
// 希望不能直接执行 可以new来执行
// let r = new Animal();
// console.log(r);
 

// 特有的东西 __proto__ prototype constructor  原型链   ie下不能直接使用__proto__
// 如何模拟new 每次new 都会产生一个对象 
// function Animal(name){
//     this.name = name; // 定义在实例上的
// }
// Animal.prototype.eat = function () { //
    
// }
// let animal1 = new Animal('动物');
// let animal2 = new Animal('动物');
// // 箭头函数是没有原型的
// console.log(animal1.__proto__ === Animal.prototype);
// console.log(animal1.__proto__.constructor === Animal);
// console.log(Animal.prototype.__proto__ === Object.prototype);

// console.log(Animal.__proto__ === Function.prototype );
// console.log(Function.prototype.__proto__ === Object.prototype);
// console.log(Object.prototype.__proto__); // 到头了

// // instance 原理就是不听的找__proto__ 看有没有

// let obj = {};
// obj.__proto__ = Animal.prototype; // 如果这个链能找到类的原型 那说明就是他的实例
// console.log(obj instanceof Animal);


// 继承 1） 继承实例属性  2） 继承原型属性
function Animal(name){
    this.name = name;
}
// 这样写 这个方法是可以被枚举
Object.defineProperty(Animal.prototype,'eat',{
    enumerable:false, // writable
    configurable:true, // 是否可配置 是否可删除
    // writable:true, // 是否能被重新改写
    get() {
        return function () { // 这是个方法
            console.log('eat');
        }
    }
});
delete Animal.prototype.eat
let animal = new Animal();
animal.eat();
// function Cat(){
//     // call 和 apply 可以改变this指向  并且让函数执行
//     Animal.apply(this,arguments); // 子类借用父类的构造方法 实现继承实例属性
// }
// Cat.prototype.__proto__ = Animal.prototype;   直接更改了 __proto__
// Object.setPrototypeOf(Cat.prototype,Animal.prototype)
// function create(parentPrototype){
//     function Fn(){ }
//     Fn.prototype = parentPrototype;
//     let obj = new Fn();
//     obj.constructor = Cat; // 在实例上增加constructor 就不会继续向上找了
//     return obj; // __proto__
// }

// 原理  原型上有prototype.constructor

// Cat.prototype = Object.create(Animal.prototype,{constructor:{value:Cat}});
// let cat = new Cat('猫');
// cat.eat();

// console.log(cat.constructor,Animal.a)
// 创建一个新的实例作为猫的原型，让这个实例可以查找到Animal的原型 这样猫的实例可以找到Animal原型的方法

// Function.__proto__===Function.prototype;

// Object.create  / __proto__ / Object.setPrototypeOf



// es6和 es5中的类的区别 es5的类可以不用new  默认通过prototype增加属性 是可枚举的  静态属性和方法 不能被子类默认继承