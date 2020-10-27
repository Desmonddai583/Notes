## 1.先从源码角度分析组件渲染原理 
默认会创建一个渲染watcher
1.vm._render(); 会创建对应的虚拟节点
    - 会调用createElement()  => h(App)
    - tag=>object  createComponent


vnode = {
    tag: `vue-component-1-app`,
    data: {on:{},hook:{init,insert,prepatch,destroy}}
    children?: undefined,
    text:undefined,
    elm: undefined,
    context:vm,
    componentOptions?:  { Ctor, propsData, listeners, tag, children },
}

2.vm._update(); 去虚拟节点创建真实节点 （path）
vm._update(vm._render(), hydrating)

默认渲染根实例时 内部可能会有一个组件节点，会调用组件虚拟节点init方法进行初始化操作，初始化操作会实例化当前的组件，调用当前组件的render方法，将渲染后的结果放到vm.$el上，在将这个结果插入到父组件中

默认流程 是先父 => 子 => 儿子 => 儿子

深度遍历的过程 dom 是一个树形结构

Vue.extend() 创造当前组件的实例


extends = mixin

- _parentVnode 占位符vnode
- $vnode = _parentVnode 占位符节点
- _vnode 指的是组件中的元素的vnode


> 周日 ssr  下午  单元测试

组件库 ：样式 
## 2.通过源码断点调试组件渲染流程
## 3.生命周期的调用顺序
## 4.全局注册和局部注册 
## 5.异步组件的原理  jsonp
## 6.掌握vue中模板编译流程 (非常饶) 


看源码 要长期自己去调试