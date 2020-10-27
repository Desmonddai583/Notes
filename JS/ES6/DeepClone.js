// 递归拷贝 保证如果是对象 生成一个空对象 将值放到对象内 
let school = {name:'zfpx',age:{age:1},fn:function(){},arr:[1,2,3]}
function deepClone(parent,c){ // {age:1}  {}
    let child = c||{};
    for(var key in parent){
        let current = parent[key];
        if(typeof current === 'object'){ //判断值是否是对象，对象另作处理
            //{age:{}}
            child[key] = Object.prototype.toString.call(current)==='[object Array]'?[]:{}
            // {age:1} {age:{}}
            deepClone(parent[key],child[key])
        }else{ 
            child[key] = parent[key];
        }
    }
    return child;
}
console.log(deepClone(school));