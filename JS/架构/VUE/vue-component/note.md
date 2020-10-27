## 安装vue-cli
```bash
npm install @vue/cli -g
```

## 快速原型工具 (可以帮我们直接解析.vue文件)
```bash
npm install @vue/cli-service-global -g
vue serve
```


## 传递方法
- props + emit/ 同步数据 v-model/.sync
- provide、inject 会造成单向数据流混乱  自己实现工具库的话 需要采用这个方式
- (尽量不要直接更改父组件数据)
- $parent $children 可以直接触发儿子的事件或者父亲的事件 (尽量不要使用 因为你不知道父亲和儿子) 防止代码不好维护  
- $broadcast $dispatch
- $attrs $listeners 表示的是所有的属性和方法的合集 可以使用v-bind 或者 v-on传递


---------------------------
- ref eventBus slot插槽的用法
- 表单组件 异步组件和菜单组件  弹框组件  render函数的使用 vue-lazyload组件
- vuex vue-router
- 面试题
- ------------------------

整理笔记