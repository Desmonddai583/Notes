/**
 * 数据类型
 * boolean 布尔型 Boolean
 */
let married: boolean = false;//是否已婚
let age: number = 0;//年龄是数字类型
//Cannot redeclare block-scoped variable 'name'.
let name: string = 'zhangsan';//window.name
//Type 'string' is not assignable to type 'number'
let arr1: number[] = [1, 2, 3];
//let arr2: Array<number> = [4, 5, 6];
//元组类型 tuple  跟数组很像，表示一个已知数量和类型的数组
//数组类型唯一，数量不确定
let zhufeng: [string, number] = ['zhangsan', 5];
zhufeng[0].length;
zhufeng[1].toFixed(2);
/* let arr3 = [];
arr3.push(1);
arr3.push(2);
arr3.push(3); */
//普通枚举类型
enum Gender {
    MALE,
    FEMALE
}
//Index signature in type 'typeof Gender' only permits reading.
console.log(Gender);
//不普通枚举 常量枚举
const enum Colors {
    Red,
    Yellow,
    Blue
}
const colors = [0, 1, 2]//
let myColors = [Colors.Red, Colors.Yellow, Colors.Blue];
//任意类型 any  anyscript
/**
 * ts给DOM BOM 都提供了一套类型声明
 * any 可以赋值给任意类型
 *     - 第三方库没有提供类型声明文件的时候
 *     - 类型转换遇到困难
 *     - 数据结构太复杂
 */
//let root: HTMLElement | null = document.getElementById('root');
// !非空断言 表示告诉TS我确定root不可能为空，所以别废话
//root!.style.color = 'red';

// null  undefined
/**
 * null和undefined是其它类型的子类型，可以赋值给其它类型，比如说数字类型
 */

let x: number;
//x = 1;
//Type 'undefined' is not assignable to type 'number'.
//如果strictNullChecks赋值为true,就不能把undefined null 赋值给 number  x
//如果strictNullChecks赋值为false,就可以undefined null 赋值给 number x
/* x = undefined;
x = null; */

let y: number | null | undefined | string;
y = 1;
y = undefined;
y = null;
y = 'a';

//void 空表示没有任何类型

function greeting(name: string): void {
    console.log(name);
    //如果strictNullChecks=true，只能返回undefined
    //return undefined;
    //Type 'null' is not assignable to type 'void'.
    return null;
}
greeting('zhufeng');


//never 永远不 永远不会出现的值
//never是其它类型(null undefined)的子类型 
//1. 作为不会返回函数的返回值类型
//当一个函数执行结束的时候， return后面的东西就是返回值的内容
function error(message: string): never {
    console.log(message);
    throw new Error(message);//抛出异常后此函数会异常中止,就永远不会有返回值了
    console.log('over message');
}
//let ret: never = error('hello');

// 还可以表示永远无法达到终点
function loop(): never {
    while (true) {

    }
}
///let ret2 = loop();

// strictNullChecks

function sum(x: number | string) {
    if (typeof x === 'number') {
        console.log(x);
    } else if (typeof x === 'string') {
        console.log(x);
    } else {
        //永远永远不可能走到这个地方
        console.log(x);
    }
}
//never void区别
// void可以赋值为null undefined,但never不包含任何值
// 定义void返回值类型的函数能正常运行，拥有never返回值的函数永远无法返回，无法中止 
//类型推断 TS会根据赋的值去猜这个变量是什么类型
let a = 1;
let b = '';
let c;

//包装对象 Wrapper Object
//JS里类型分成二种 原始数据类型(string number boolean undefined null symbol) 对象类型 引用类型
//原始类型没有属性和方法的
let name2 = 'zhufeng';
console.log('name2.toUpperCase()===', name2.toUpperCase());
//当你在调用基本类型的方法的时候，JS会迅速对原始类型进行包装成对象。调用是对象上的方法
let isOk: boolean = true;
let isOk2: boolean = Boolean(1);
//String.prototype.toUpperCase;
new String(name2).toUpperCase();

//联合类型
let name3: string | number;
name3 = '';
name3.substring(0);
name3 = 1;
name3.toFixed(0);

// 类型断言 单元测试
//类型断言可以把一个联合的变量指定为一个更加具体的类型
//不能把联合断言为一个不存在的类型
let name4: string | number;
(name4 as string).length;
(name4 as number).toFixed(2);
//(<number>name4).toFixed(2);


//字面量类型
//可以把字符串、数字、布尔值字面量组成一个联合类型
//type是自定义一个类型的意思吗? 是的 number string
//type是TS的关键字，用来声明一个新的类型，类似于number string
type myType = 1 | 'one' | true;

let t1: myType = 1;
let t2: myType = 'one';
let t3: myType = true;

//字面量和联合类型
//字面量是值的联合，联合是类型的联合
// 0x开头的是16进制 0o开头是8进制 不加前缀是十进制 0b开头的是2进制 
let a11 = 0b1;




//如果文件里出现了export或者import ,ts会把这个文件当成一个模块 
//这样的话里面的变量会成为私有变量，就不会和全局变量冲突
export { }