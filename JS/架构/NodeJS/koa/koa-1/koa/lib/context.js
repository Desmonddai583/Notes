let context = {
//     get url(){ // 这里也是一个代理的机制 相当于你去 ctx.url   ctx指代的并不是我们的context文件指的是我们在应用中拷贝出来的一份 ，拷贝的一份上 context.request.url 
//         return this.request.url
//     },
//     get path(){
//         return this.request.path
//     } 
}
// defineProperty proxy

function defineGetter(target,key){
    context.__defineGetter__(key,function () { // context.url = > context.request.url
        // console.log(this.__proto__.__proto__ === context);
        return this[target][key];
    })
}

function defineSetter(target,key){
    context.__defineSetter__(key,function (value) { 
        this[target][key] = value;
    })
}
defineGetter('request','url');
defineGetter('request','path');
defineGetter('request','query');

defineGetter('response','body');
defineSetter('response','body');
module.exports = context;


// ctx.req
// ctx.request.req
// ctx.request.xxx
// ctx.xxx 


// let obj = {
//     url:{
//         a:1
//     }
// }
// // obj.a => obj.url.a
// obj.__defineGetter__('a',function () {
//     return obj.url.a
// })
// console.log(obj.a)