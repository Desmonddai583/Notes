// 节约性能  先把真是节点 用 一个对象来表示出来 ，在通过对象渲染到页面上
// 前端操作dom的时候 排序 -》正序反序 删除

// diff 新的节点 在生成一个对象

// vue代码基本上不用手动操作dom


// 虚拟dom 只是一个对象
// vue template  render函数  s

// 初始化 将虚拟节点 渲染到页面
// <div id="container"><span style="color:red">hello</span>zf</div>

// h=> createElement
import {h,render,patch} from './vdom'
let oldVnode = h('div',{id:'container'},
    h('li',{style:{background:'red'},key:'a'},'a'),
    h('li',{style:{background:'yellow'},key:'b'},'b'),
    h('li',{style:{background:'blue'},key:'c'},'c'),
    h('li',{style:{background:'pink'},key:'d'},'d'),
);
let container = document.getElementById('app');
render(oldVnode,container);
let newVnode = h('div',{id:'aa'},
    h('li',{style:{background:'pink'},key:'e'},'e'),
    h('li',{style:{background:'blue'},key:'a'},'a'),
    h('li',{style:{background:'yellow'},key:'f'},'f'),
    h('li',{style:{background:'red'},key:'c'},'c'),
    h('li',{style:{background:'red'},key:'n'},'n'),
)
setTimeout(() => {
    patch(oldVnode,newVnode);
}, 1000);
// patchVnode 用新的虚拟节点 和老的虚拟节点做对比 更新真实dom元素






// {
//     tag:'div',
//     props:{},
//     children:[{
//         tag:undefined,
//         props:undefined,
//         children:undefined,
//         text:'hello'
//     }]
// }
// <div>hello</div>
// new Vue({
//     render(h){
//         return h('div',{},'hello')
//     }
// })