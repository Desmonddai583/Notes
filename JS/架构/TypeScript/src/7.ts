/**
 * 结构类型系统 兼容性
 */
//接口的兼容性
//如果传入的变量和声明的类型不匹配，TS会进行兼容性检查 
interface Animal {
    name: string;
    age: number
}
interface Person {
    name: string;
    age: number;
    gender: number
}
//原理Duck-Check 只要说目标类型中声明的变量在源类型中都存在那么就是兼容的
function getName(animal: Animal): string {
    return animal.name;
}
let p: Person = { name: 'zhufeng', age: 10, gender: 1 }
getName(p);

//接口的兼容性 
//基本类型的兼容性
let num: string | number;// 可以接收字符串，也可以接受number
let str: string = 'zhufeng';
num = str;


let num2: {
    toString(): string
}
let str2: string = 'jiagou';
num2 = str2;
namespace f {
    //类的兼容性
    // 在TS中是结构类型系统，只会比较结构而不在意类型
    class Animal {
        name: string
    }
    class Bird extends Animal {

    }
    let a: Animal;
    a = new Bird();

    let b: Bird;
    b = new Animal();//不行

    b = { name: 'zhufeng' };

}

namespace g {
    //函数的兼容性
    type sumFunc = (a: number, b: number) => number;
    let sum: sumFunc;
    function f1(a: number, b: number): number {
        return 1;
    }
    sum = f1;
    //少传一个参数也是可以的
    function f2(a: number): number {
        return 1;
    }
    sum = f2;
    //少传2个参数也是可以的
    function f3(): number {
        return 1;
    }
    sum = f3;
    //参数多一个可不行
    function f4(a: number, b: number, c: number): number {
        return 1;
    }
    //sum = f4;



    type GetPerson = () => { name: string, age: number }
    let getPerson: GetPerson;
    function g1() {
        return { name: 'zhufeng', age: 10 };
    }
    getPerson = g1;
    function g2() {
        return { name: 'zhufeng', age: 10, home: 'beijing' };
    }
    getPerson = g2;
    function g3() {
        return { name: 'zhufeng' };
    }
    //getPerson = g3;//多属性可以，少属性不行
    //函数参数的双向协变
    //当比较函数参数的时候，只有当源函数的参数能够赋值给目标函数或者反过来的时候才能赋值成功
    let sourceFunc = (arg: number | string) => { }
    let target1Func = (arg: number | string) => { }
    sourceFunc = target1Func;
    let target2Func = (arg: number | string | boolean) => {
        //这里肯定能处理boolean
    }
    sourceFunc = target2Func;
    let target3Func = (arg: number) => { }
    // sourceFunc = target3Func;

    interface Event {
        timestamp: number
    }
    interface MouseEvent extends Event {
        eventX: number
        eventY: number
    }
    interface KeyEvent extends Event {
        keyCode: number
    }
    document.addEventListener
    function addEventListener(eventType: string, handler: (event: Event) => void) {

    }
    addEventListener('click', (event: MouseEvent) => { });
    addEventListener('click', (event: Event) => { });
    addEventListener('click', (event: KeyEvent) => { });
}
//枚举的兼容 性
enum Colors {
    Red,
    Yellow
}
//枚举类型和数字类型兼容
let c: Colors;
c = Colors.Red;//0
c = 0;

let n: number;
n = Colors.Yellow;

//泛型的兼容性
interface Empty<T> {

}
let x!: Empty<string>;
let y!: Empty<number>;
x = y;

interface NotEmpty<T> {
    data: T
}
let x2!: NotEmpty<string>;//type x2={data:string}
let y2!: NotEmpty<number>;//type y2={data:number}
x2 = y2;

export { }