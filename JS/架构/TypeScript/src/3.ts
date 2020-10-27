/**
 * 类 Class
 * TS声明一个类的时候，其实得到了二个类型
 * 1. 实例的类型
 * 2. 类本身构造函数的类型
 */
class Person {
    name: string = '';
    getName(): void {
        console.log(this.name);
    }
}
//Person是实例的类型
let p1: Person = new Person();
p1.name = 'zhufeng';
p1.getName();


// 存取器
class User {
    public readonly PI = 3.14;
    //myName: string = ''
    constructor(public myName: string) {
        //this.myName = myName;
    }
    get name(): string {
        return this.myName;
    }
    set name(value) {
        this.myName = value.toUpperCase();
    }
}
let user = new User('zhufeng');
//user.name = 'zhufeng';
console.log(user);
//Cannot assign to 'PI' because it is a read-only property.
//user.PI = 3.15;
//readonly const 区别
//readonly是在编译阶段进行的检查 const是在运行阶段进行的检查
//Parameter 'a' implicitly has an 'any' type
//
/* function sum(a) {
    console.log(a);
} */
/**
 * 
 */
//public 不能修饰类
class Father {
    static className = "Father"
    static getClassName() {
        console.log(Father.className);
    }
    //类的public属性意味着这个属性可以被自己类本身，子类和其它类访问
    //public name: string
    //类的protected属性表示这个属性只有自己类本身和子类能访问，其它类不能访问
    //protected age: number;
    //类的private私有属性表示这个属性只能被本身访问，子类和其它 类不能访问
    //private money: number;
    constructor(public name: string, protected age: number, private money: number) {
        /*  
         this.name = name;
         this.age = age;
         this.money = money; 
         */
    }
    getMoney() {
        console.log(this.money);
    }
}
class Child extends Father {
    // Child.__proto__= Father
    constructor(name: string, age: number, money: number) {
        super(name, age, money);
    }
    getName() {
        console.log(this.name);
    }
    getAge() {
        console.log(this.age);
    }
}
let child = new Child('zhufeng', 10, 100);
child.getName();
child.getAge();
child.getName();
child.name;
//child.age;
console.log(Child.className);
Child.getClassName();

/**
 * 装饰器
 * react @connect
 * nest.js 大量会用到装饰器
 * 类装饰器 装饰类的 用在类声明之前，用来监视、修改和替换类的定义
 * enhancer其实是一个函数
 */
namespace a {
    //同名的类和接口定义的类型，属性会进行合并
    interface Person {
        name: string;
        eat: () => void
    }
    //target指的是 Person类
    // typeof Person /Function /new () => Person
    type Ptype = typeof Person;
    function enhancer(target: Function) {
        target.prototype.name = 'zhufeng';
        target.prototype.eat = function () {
            console.log('this.name', this.name);
        }
    }
    //type Person = {name:string,eat:Function};实例的类型
    //构造函数本身的类型  
    @enhancer
    class Person { constructor(public a: string) { } }
    @enhancer
    class Person2 { constructor(public a: string) { } }
    let p: Person = new Person('zhufeng');
    let p2: Person2 = new Person2('zhufeng');
    p.name;
    p.eat();
}
//装饰器工厂
namespace b {
    //同名的类和接口定义的类型，属性会进行合并
    interface Person {
        name: string;
        eat: () => void
    }
    //target指的是 Person类
    // typeof Person /Function /new () => Person
    type Ptype = typeof Person;
    function enhancer(name: string) {
        return function enhancer(target: Function) {
            target.prototype.name = name;
            target.prototype.eat = function () {
                console.log('this.name', this.name);
            }
        }
    }
    //react connect(mapStateToProps,mapDispatchToProps)
    @enhancer('zhufeng')
    class Person { constructor(public a: string) { } }
}
namespace b {
    //同名的类和接口定义的类型，属性会进行合并
    interface Person {
        name: string;
        eat: () => void
    }
    function enhancer(target: any) {
        return class {
            age: number = 10;
            constructor(age: number) {
                this.age = age;
            }
            name: string = 'jiagou';
            eat() {
                console.log(this.name);
            }
        }
    }

    @enhancer
    class Person {
        age: number = 10;
        constructor(age: number) {
            this.age = age;
        }
    }
    let p = new Person(10);
    p.name;
    p.eat();
}
/**
 * 属性装饰器
 * 方法装饰器 
 * 
 */
namespace c {
    /**
     * 属性装饰器有两个参数
     * @param target  如果是静态成员，target就是类的构造函数，如果是实例成员就是类的原型对象
     * @param property 方法或者属性的名称
     */
    function upperCase(target: any, property: string) {
        let value = target[property];
        const getter = () => value;
        const setter = (newVal: string) => {
            value = newVal.toUpperCase();
        }
        if (delete target[property]) {
            Object.defineProperty(target, property, {
                get: getter,
                set: setter,
                enumerable: true,
                configurable: true
            });
        }
    }
    /**
     * 
     * @param target  如果静态成员，那么target是类的构造函数，如果是实例成员是类的原型对象
     * @param property 方法的名称
     * @param descriptor 方法的描述器
     */
    function noEnumerable(target: any, property: string, descriptor: PropertyDescriptor) {
        descriptor.enumerable = false;
    }
    class Person {
        @upperCase
        name: string = 'zhufeng'
        @noEnumerable
        getName() {
            console.log(this.name);
        }
    }
    let p = new Person();
    p.name = 'zhufeng';
    console.log(p, p.name);

}
//参数装饰器  nest.js用到了
namespace d {
    interface Person {
        age: number;
    }
    /**
     * @param target  静态成员来说是类的构造函数，对于实例 成员来说就是类的原型对象prototype
     * @param methodName 方法名
     * @param paramsIndex  参数的索引
     */
    function addAge(target: any, methodName: string, paramsIndex: number) {
        console.log(target, methodName, paramsIndex);
        target.age = 10;
    }
    class Person {
        login(username: string, @addAge password: string) {
            console.log(username, password, this.age);
        }
    }
    let p = new Person();
    p.login('zhangsan', '123456');
}
/**
 * 静态是属于类的 非静态是属于实例的
 * Person.className
 * new Person().name;
 * 装饰器的执行顺序
 * 有多个装饰器的时候，从最后一个参数依次向前执行
 * 方法和方法参数中参数装饰器先执行
 * 类装饰器总是最后执行
 * 方法和属性装饰器，谁在前面先执行，因为参数属于方法的一部分，所以参数会紧贴着方法执行
 * 1.不同类别从上往下
 * 2. 同一类别至下而上
 * 3.类总是最后的
 * 
 * 1. 从内从外
 */
namespace e {
    function ClassDecorator1() {
        return function (target: any) {
            console.log('类装饰1');
        }
    }
    function ClassDecorator2() {
        return function (target: any) {
            console.log('类装饰2');
        }
    }
    function propertyDecorator(name: string) {
        return function (target: any, property: string) {
            console.log('属性装饰器', name);
        }
    }
    function ParameterDecorator1() {
        return function (target: any, methodName: string, paramIndex: number) {
            console.log('参数装饰器1');
        }
    }
    function ParameterDecorator2() {
        return function (target: any, methodName: string, paramIndex: number) {
            console.log('参数装饰器2');
        }
    }
    function MethodDecorator() {
        //方法也是属性  methodName greet  
        return function (target: any, methodName: string, descriptor: PropertyDescriptor) {
            console.log('方法装饰器');
        }
    }
    @ClassDecorator1()
    @ClassDecorator2()
    class Person {
        @propertyDecorator('name')
        name: string = 'zhufeng';
        @propertyDecorator('age')
        age: number = 10;
        @MethodDecorator()
        greet(@ParameterDecorator1() p1: string, @ParameterDecorator2() p2: string) {

        }
    }
}
/**
 * 属性装饰器 name
 * 属性装饰器 age
 * 参数装饰器2
 * 参数装饰器1
 * 方法装饰器
 * 类装饰2
 * 类装饰1
 */