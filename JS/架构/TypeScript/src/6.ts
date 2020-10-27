/**
 * 泛型 重点 难点
 * 在定义函数、接口和类的时候，不预先提定具体的类型而是使用的时候指定
 * 泛型也像是一个参数
 */
function createArray<T>(length: number, value: T): T[] {
    let result: T[] = [];
    for (let i = 0; i < length; i++) {
        result[i] = value;
    }
    return result;
}
let result = createArray<number>(3, 1);
console.log(result);

//类数组
function sum(...args: number[]) {
    let args2: IArguments = arguments;
    for (let i = 0; i < args.length; i++) {
        console.log(args[i]);
    }
}
sum(1, 2, 3);

//let root = document.getElementById('root');
//let children: HTMLCollection | undefined = root?.children;
//let childNodes: NodeListOf<ChildNode> = root?.childNodes;
//泛型类
class MyArray<T>{
    private list: T[] = [];
    add(value: T) {
        this.list.push(value);
    }
}
let arr = new MyArray<number>();
arr.add(1);
// 接口里使用泛型
//使用接口约束泛型的时候，泛型既可以定义在接口名称里，也可以定义在函数里
//如果在定义接口名称里的泛型，需要在使用这个接口类型的时候就要传入具体值进行确定
//如果是定义在函数里的时候，则可以在调用函数的时候才确定
interface Calculate<A = number> {
    <B>(a: A, b: B): A
}
let add: Calculate<number> = <C>(a: number, b: C) => {
    return a;
}
add<string>(1, 'a');

//默认泛型
function createArray2<T = number>(length: number, value: T): T[] {
    let result: T[] = [];
    for (let i = 0; i < length; i++) {
        result[i] = value;
    }
    return result;
}

let result2 = createArray2(3, 's');
console.log(result);

//泛型约束 
//默认情况下，不能调用泛型上的任何属性和方法，因为在定义的时候根本不知道将会传入什么值
//用接口去约束泛型
interface LengthWise {
    length: number
}
//用LengthWise约束泛型T，
function logger<T extends LengthWise>(val: T) {
    console.log(val.length);
}
logger<string>('d');

//泛型类型别名
type Cart<T> = { list: T[] } | T[];
let c1: Cart<string> = { list: ['1'] };
let c2: Cart<number> = [1, 2, 3];



export { }

