class Animal {
    constructor(name){
        this.name = name; // 增加到实例上
        // this.age = 18;
    }
    // age = 18; // es7 不是原型上的是实例上的
    // 类的访问器 Object.defineProperty中的get方法
    get eat(){ // Animal.prototype.eat = 123;
        return 123
    }
    set eat(value){
        console.log(value)
    }
    // 默认es6 只支持静态方法
    static hello(){
        console.log('hello')
    }
    // static a = 1;  
    static get a(){ // es6 中静态属性的方法
        return 1
    }
    drink(){
        console.log('父亲 喝水')
    }
}

// call + Object.create() + Cat.__proto__ = Animal
class Cat extends Animal {
    constructor(name){ // 如果没有constructor 默认使用父类的
        // 这里的super指向的是父类 默认里面的this就是子类
        super(name); // Animal.call(this)
    }
    drink(){
        // super = Super.prototype 这个super不能单独打印
        super.drink();
        console.log('子 喝水')
    }
    static aa(){
        console.log(super.a)
    }
}
let cat = new Cat();
console.log(Cat.aa());
// super 指向有两种可能 在constructor 和 static中指向的是父类
// 在子类的原型方法中指向的是父类原型
// 静态方法 就是通过类来调用的方法


