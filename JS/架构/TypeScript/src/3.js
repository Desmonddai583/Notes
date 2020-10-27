"use strict";
var __extends = (this && this.__extends) || (function () {
    var extendStatics = function (d, b) {
        extendStatics = Object.setPrototypeOf ||
            ({ __proto__: [] } instanceof Array && function (d, b) { d.__proto__ = b; }) ||
            function (d, b) { for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p]; };
        return extendStatics(d, b);
    };
    return function (d, b) {
        extendStatics(d, b);
        function __() { this.constructor = d; }
        d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
    };
})();
/**
 * 类 Class
 * TS声明一个类的时候，其实得到了二个类型
 * 1. 实例的类型
 * 2. 类本身构造函数的类型
 */
var Person = /** @class */ (function () {
    function Person() {
        this.name = '';
    }
    Person.prototype.getName = function () {
        console.log(this.name);
    };
    return Person;
}());
//Person是实例的类型
var p1 = new Person();
p1.name = 'zhufeng';
p1.getName();
// 存取器
var User = /** @class */ (function () {
    //myName: string = ''
    function User(myName) {
        this.myName = myName;
        this.PI = 3.14;
        //this.myName = myName;
    }
    Object.defineProperty(User.prototype, "name", {
        get: function () {
            return this.myName;
        },
        set: function (value) {
            this.myName = value.toUpperCase();
        },
        enumerable: true,
        configurable: true
    });
    return User;
}());
var user = new User('zhufeng');
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
var Father = /** @class */ (function () {
    //类的public属性意味着这个属性可以被自己类本身，子类和其它类访问
    //public name: string
    //类的protected属性表示这个属性只有自己类本身和子类能访问，其它类不能访问
    //protected age: number;
    //类的private私有属性表示这个属性只能被本身访问，子类和其它 类不能访问
    //private money: number;
    function Father(name, age, money) {
        this.name = name;
        this.age = age;
        this.money = money;
        /*
         this.name = name;
         this.age = age;
         this.money = money;
         */
    }
    Father.getClassName = function () {
        console.log(Father.className);
    };
    Father.prototype.getMoney = function () {
        console.log(this.money);
    };
    Father.className = "Father";
    return Father;
}());
var Child = /** @class */ (function (_super) {
    __extends(Child, _super);
    // Child.__proto__= Father
    function Child(name, age, money) {
        return _super.call(this, name, age, money) || this;
    }
    Child.prototype.getName = function () {
        console.log(this.name);
    };
    Child.prototype.getAge = function () {
        console.log(this.age);
    };
    return Child;
}(Father));
var child = new Child('zhufeng', 10, 100);
child.getName();
child.getAge();
child.getName();
child.name;
//child.age;
console.log(Child.className);
Child.getClassName();
//JS  final class 只读类
