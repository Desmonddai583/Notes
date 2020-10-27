/**
 * 函数
 */
function hello(name: string): void {
    console.log('hello', name);
}
hello('zhufeng');

//函数表达式
type UserFunction = (a: string, b: string) => string;
let getUserName: UserFunction = function (firstName: string, lastName: string): string {
    return firstName + lastName;
}
//可选参数 必须是最后一个
function print(name: string, age?: number): void {
    console.log(name, age);
}
print('zhufeng');
print('zhufeng', 10);

//默认参数
function ajax(url: string, method: string = 'GET') {
    console.log(url, method);
}
ajax('/users');

//剩余参数
function sum(prefix: string, ...numbers: number[]) {
    return prefix + numbers.reduce((acc, curr) => acc + curr, 0);
}
console.log(sum('$', 1, 2, 3));
//函数的重载
let obj: any = {};

function attr(val: number): void;
function attr(val: string): void;
function attr(val: number | string) {
    if (typeof val === 'string') {
        obj.name = val;
    } else if (typeof val === 'number') {
        obj.age = val;
    }
}
attr('zhufeng');
attr(10);
console.log(obj);

//或者 都传字符串，或者都 传number 函数声明 签名 重载
function sum2(a: string, b: string): any;
//Function implementation is missing or not immediately following the declaration.ts(2391)
function sum2(a: number, b: number): any;
function sum2(a: string | number, b: string | number) {

}
sum2(1, 2);
sum2('a', 'b');
//No overload matches this call 没有为此调用找到匹配的重载
//sum2(1, 'b');
//=> 1.定义箭头的时候会用到=>  2. 定义函数类型的时候=>


