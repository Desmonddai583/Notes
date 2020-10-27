// 对象的方法 Object.assign

// 对象可以简写，如果key和value相等则可以简写
let name = 'zfpx';
let age = 9
let obj = {
    name,
    age,
    fn(){
        console.log('ok')
    }
};
console.log(obj)
// 对象新增的方法  Object.setPrototypeOf()

let o2 = {
    age:18,
    name:'jw'
}
let o1 = {
    name:'zfpx',
    __proto__:o2,
    getO2Name(){
        return super.name;
    }
}
// __proto__ 每一个对象上都有这个东西，如果自己家找不到会通过这个链向上找
// Object.setPrototypeOf(o1,o2);

console.log(o1.getO2Name());
// super在子对象中指向的是__proto__对应的内容