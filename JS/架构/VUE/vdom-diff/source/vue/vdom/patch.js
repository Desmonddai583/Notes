// 这个文件除了第一次的初始化渲染之外

export function render(vnode,container){ // 让虚拟节点 渲染成真实节点
    let el = createElm(vnode);
    container.appendChild(el);
    return el
}
// 创建真实节点
function createElm(vnode){
    let {tag,children,key,props,text} = vnode;
    if(typeof tag === 'string'){
        // 标签  一个虚拟节点 对应着他的真实节点  主要是做一个映射关系
        vnode.el = document.createElement(tag);
        updateProperties(vnode);
        children.forEach(child => { // child是虚拟节点
            return render(child,vnode.el); // 递归渲染当前孩子列表
        });
    }else{
        // 文本
        vnode.el = document.createTextNode(text);
    }
    return vnode.el
}
// 更新属性也会调用此方法  oldProps={a:1,style:{fontSize:18px}}
function updateProperties(vnode,oldProps={}){ 
    // oldProps = {id:container,style:{background:red}}
    // newProps = {id:aa,style:{background:yellow}}}
    let newProps = vnode.props || {}; // 获取当前老节点中的属性 
    let el = vnode.el; // 当前的真实节点

    let newStyle = newProps.style || {};
    let oldStyle = oldProps.style || {};
    
    // 稍后会用到这个更新操作 主要的作用就是 根据新的虚拟节点 来修改dom元素
    for(let key in oldStyle){
        if(!newStyle[key]){
            el.style[key] = ''
        }
    }
    // 如果下次更新时 我应该用新的属性 来更新老的节点 
    // 如果老的中有属性 新的中没有
    
    for(let key in oldProps){
        if(!newProps[key]){
            delete el[key]; // 如果新的中没有这个属性了 那就直接删除掉dom上的这个属性
        }
    }
    // 我要先考虑一下 以前有没有
    for(let key in newProps){
        if(key === 'style'){ // 如果是style的话 需要再次遍历添加
            for(let styleName in  newProps.style){ // {color:red}
                // el.style.color = 'red'
                el.style[styleName] = newProps.style[styleName]
            }
        }else if(key === 'class'){
            el.className= newProps.class
        }else{ // 给这个元素添加属性 值就是对应的值
            el[key] = newProps[key]
        }
    }
}

export function patch(oldVnode,newVnode){
    // 1) 先比对 标签一样不一样 
    if(oldVnode.tag !== newVnode.tag){ // 以前是div 现在是p标签
        // 必须拿到当前元素的父亲 才能替换掉自己
        oldVnode.el.parentNode.replaceChild(createElm(newVnode),oldVnode.el)
    }
    // 2) 比较文本了 标签一样 可能都是undefined
    if(!oldVnode.tag){
        if(oldVnode.text !== newVnode.text){ // 如果内容不一致直接根据当前新的元素中的内容来替换到文本节点
            oldVnode.el.textContent = newVnode.text;
        }
    }

    // 标签一样 可能属性不一样了
    let el = newVnode.el =  oldVnode.el; // 标签一样复用即可
    updateProperties(newVnode,oldVnode.props); // 做属性的比对

    // 必须要有一个根节点
    // 比较孩子 
    let oldChildren = oldVnode.children || [];
    let newChildren = newVnode.children || [];

    // 老的有孩子 新的有孩子 updateChildren
    if(oldChildren.length > 0 && newChildren.length > 0){
        updateChildren(el,oldChildren,newChildren); // 不停的递归比较
    }else if(oldChildren.length > 0){  // 老的有孩子 新的没孩子 
        el.innerHTML = ''
    }else if(newChildren.length > 0){ // 老的没孩子 新的有孩子
        for(let i = 0; i < newChildren.length ;i++){
            let child = newChildren[i];
            el.appendChild(createElm(child)); // 将当前新的儿子 丢到老的节点中即可
        }
    }
    return el;
}
function isSameVnode(oldVnode,newVnode){
    // 如果两个人的标签和key 一样我认为是同一个节点 虚拟节点一样我就可以复用真实节点了
    return (oldVnode.tag === newVnode.tag) && (oldVnode.key === newVnode.key)
}
function updateChildren(parent,oldChildren,newChildren){
    // vue增加了很多优化策略 因为在浏览器中操作dom最常见的方法是 开头或者结尾插入
    // 涉及到正序和倒序
    let oldStartIndex = 0; // 老的索引开始
    let oldStartVnode = oldChildren[0]; // 老的节点开始
    let oldEndIndex = oldChildren.length - 1;
    let oldEndVnode = oldChildren[oldEndIndex];


    let newStartIndex = 0; // 新的索引开始
    let newStartVnode = newChildren[0]; // 新的节点开始
    let newEndIndex = newChildren.length - 1;
    let newEndVnode = newChildren[newEndIndex];

    function makeIndexByKey(children){
        let map = {};
        children.forEach((item,index)=>{
            map[item.key] = index
        });
        return map; // {a:0,b:1...}
    }
    let map = makeIndexByKey(oldChildren);
    while(oldStartIndex<=oldEndIndex && newStartIndex <= newEndIndex){
        // 向后插入元素
        if(!oldStartVnode){
            oldStartVnode = oldChildren[++oldStartIndex];
        }else if(!oldEndVnode){
            oldEndVnode = oldChildren[--oldEndIndex]
        }else  if(isSameVnode(oldStartVnode,newStartVnode)){  // 先开前面是否一样
            patch(oldStartVnode,newStartVnode);// 用新的属性来更新老的属性,而且还要递归比较儿子
            oldStartVnode = oldChildren[++oldStartIndex];
            newStartVnode = newChildren[++newStartIndex]
        // 当前向前插入
        }else if(isSameVnode(oldEndVnode,newEndVnode)){ // 从后面比较看是否一样
            patch(oldEndVnode,newEndVnode); // 比较孩子 
            oldEndVnode = oldChildren[--oldEndIndex];
            newEndVnode = newChildren[--newEndIndex];
        // 倒叙功能 abcd  dcba
        }else if(isSameVnode(oldStartVnode,newEndVnode)){
            patch(oldStartVnode,newEndVnode);
            parent.insertBefore(oldStartVnode.el,oldEndVnode.el.nextSibling);
            oldStartVnode = oldChildren[++oldStartIndex];
            newEndVnode = newChildren[--newEndIndex]
            // 这个是比对将尾部插入到了前面
        }else if(isSameVnode(oldEndVnode,newStartVnode)){
            patch(oldEndVnode,newStartVnode);
            parent.insertBefore(oldEndVnode.el,oldStartVnode.el);
            oldEndVnode = oldChildren[--oldEndIndex];
            newStartVnode = newChildren[++newStartIndex]
        }else {
            // 会先拿新节点的第一项 去老节点中匹配，如果匹配不到直接将这个节点插入到老节点开头的前面，如果能查找到则直接移动老节点
            // 可能老节点中还有剩余 则直接删除老节点中剩余的属性
            let moveIndex = map[newStartVnode.key];
            if(moveIndex == undefined){
                parent.insertBefore(createElm(newStartVnode),oldStartVnode.el);
            }else{
                // 我要移动这个元素
                let moveVnode = oldChildren[moveIndex];
                oldChildren[moveIndex] = undefined;
                parent.insertBefore(moveVnode.el,oldStartVnode.el);
                patch(moveVnode,newStartVnode);
            }
            // 要将新节点的指针向后移动
            newStartVnode = newChildren[++newStartIndex]
        } 
        // 老的尾巴和新的头去比 将老的尾巴移动到老的头的前面
        // 还有一种情况 
        // 倒叙和正序
    }
    if(newStartIndex<=newEndIndex){ // 如果到最后还剩余 需要将剩余的插入
        for(let i = newStartIndex ; i <=newEndIndex; i++){
            // 要插入的元素
            let ele = newChildren[newEndIndex+1] == null? null:newChildren[newEndIndex+1].el;
            parent.insertBefore(createElm(newChildren[i]),ele);
            // 可能是往前面插入  也有可能是往后面插入
            // insertBefore(插入的元素,null) = appendChild
            // parent.appendChild(createElm(newChildren[i]))
        }
    }
    if(oldStartIndex <= oldEndIndex){
        for(let i = oldStartIndex; i<=oldEndIndex;i++){
            let child = oldChildren[i];
            if(child != undefined){
                parent.removeChild(child.el)
            }
        }
    }
    // 循环的是 尽量不要使用索引作为key 可能会导致重新创建当前元素的所有子元素
}