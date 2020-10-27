import {vnode} from './create-element'
export default function h(tag,props,...children){
    let key = props.key;
    delete props.key; // 属性中不包括key属性
    children = children.map(child=>{
        if(typeof child === 'object'){
            return child
        }else{
            return vnode(undefined,undefined,undefined,undefined,child)
        }
    })
    // key 的作用 可以比对两个虚拟节点是否是同一个
    return vnode(tag,props,key,children);
} 
