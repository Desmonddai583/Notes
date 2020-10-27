/**
 * 接口 行为的抽象 对象的形状
 */
/**
 * 1.对象的形状
 */
namespace a {
    interface Speakable {
        name: string;
        speak(): void;
    }
    let person: Speakable = {
        name: 'zhufeng',
        speak() { }
    }
}
namespace b {
    /*
    行为的抽象
    **/
    interface Speakable {
        speak(): void
    }
    interface Eatable {
        eat(): void
    }
    class Person implements Speakable, Eatable {
        speak() {
            throw new Error("Method not implemented.");
        }
        eat(): void {
            throw new Error("Method not implemented.");
        }
    }
}
namespace c {
    //任意属性
    /*  interface Person {
         name: string;
         age: number;
         [propName: string]: any
     } */

    interface Person extends Record<string, any> {
        name: string;
        age: number;
        //Cannot assign to 'PI' because it is a read-only property.
        readonly PI: number
    }

    let p: Person = {
        PI: 3.14,
        name: 'zhufeng',
        age: 10,
        //Object literal may only specify known properties, and 'home' does not exist in type 'Person'
        home: 'beijing',
        today: 1
    }
    //p.PI = 3.15;
}
//函数接口类型 
namespace d {
    //type Cost = (price: number) => number;
    interface Cost {
        (price: number): number
    }
    let cost: Cost = function (price: number): number {
        return price * .8;
    }
    interface Person {
        cost: (price: number) => number
    }
    let p: Person = {
        cost
    }

}

namespace e {
    //重载同样一个方法，方法名一样，但是参数的类型不同
    function add(a: number): string | number;
    function add(a: string): string | number;
    function add(a: number | string): string | number {
        if (typeof a === 'number') {
            return 1;
        }
        if (typeof a === 'string') {
            return '';
        }
        return '';
    }

}
/**
 * 可索引接口
 * 对数组和对象进行约束的
 */
namespace f {
    interface UserInterface {
        [index: number]: string
    }
    let arr: UserInterface = ['1', '2'];

    //let obj: UserInterface = { 0: 'a', 1: 'b' };
    let obj: UserInterface = { '2': '2' };

}

namespace g {
    //类接口 类的类型
    //用接口去约束了类
    interface Speakable {
        name: string;
        speak(words: string): void
    }
    class Dog implements Speakable {
        name: string;
        speak(words: string): void {
            console.log(words);
        }
    }
    let dog = new Dog();
    dog.speak('汪汪汪');
}

namespace h {
    class Animal {

        constructor(public name: string, public age: number) {

        }
    }
    //用接口约束类
    interface WithNameClazz {
        new(name: string, age: number): Animal
    }
    function create(clazz: WithNameClazz, name: string, age: number) {
        return new clazz(name, age);
    }
    let a = create(Animal, 'zhufeng', 10);
    console.log(a);

}   