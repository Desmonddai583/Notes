const parser = (str) => {
    const obj = {};
    str.replace(/([^=&]+)=([^=&]+)/g,function () {
        obj[arguments[1]] = arguments[2]
    })
    return obj;
}
const stringify = (obj)=>{
    const arr = [];
    for(let key in obj){
        arr.push(`${key}=${obj[key]}`)
    }
    return arr.join('&')
}
export {
    parser,
    stringify
}
// 1.测试代码会污染你的正常编写的代码
// 2.如果删除了测试就没有保留下来 下次想看能否通过 还需要重写
// 3.代码要是模块化 jest

// console.log(parser('name=zf&age=10')); // {name:'zf',age:10}
// console.log(stringify({
//     name: 'zf',
//     age: 10
// })); // 'name=zf&age=10'