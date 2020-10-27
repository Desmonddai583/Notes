// 数组的新方法 将类数组转化成数组
// 常见的类数组 arguments domCollection
let result = Array.from({0:1,1:2,length:3});
// Array.from = Array.prototype.slice.call(arguments,0)
let result = Array.prototype.slice.call({0:1,1:2,length:2},0);

// console.log([...{0:1,1:2,length:2}]);
 // 类数组 如果要转化成对象或者能遍历 需要有一个迭代器方法
console.log(result);



console.log(Array.of(3));// [3]
console.log(Array(3)); // new Array(3)
console.log(Array(3).fill(3));



// reduce收敛 叠加
Array.prototype.myReduce = function(callback,pre){
    // 看有没有pre 有就有传进来的 没有就用数组的第一项
    let prev = pre||this[0]; //数组的第一项
    for(var i = pre?0:1;i<this.length;i++){
        prev = callback(prev,this[i],i,this);
    }
    return prev
}
let result = [1,2,3,4,5].myReduce((prev,next,index,current)=>{
    if(index == current.length -1)return (prev+next)/current.length;
    return prev+next
}); // 参数代表手动指定数组的第一项，数组的长度不会变
console.log(result);



// filter过滤 返回ture表示当前项留下，返回false表示不留
Array.prototype.myFilter = function(callback){
    let arr = [];
    for(let i = 0;i<this.length;i++){
        callback(this[i],i)?arr.push(this[i]):void 0;
    }
    return arr;
}

let filterArr = [1,2,3,4,5].myFilter(function(item,index){
    if(item>3)return true
});
console.log(filterArr);



// some 和every 是一对 some是找true找到了返回true  every找false找到了就返回false
let flag = [1,2,3].every(function(item,index){
    console.log('11111');
    return item===1
});
console.log(flag);



// find找到后返回的是当前项找不到返回undefined,找到后停止'



// 数组的includes 数组的indexOf 
let result = [2,3,4,5,6].includes(3);
console.log(result)