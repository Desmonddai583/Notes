## `Vue`源码剖析

## 一.目录源码剖析

- `compiler`(编译模块) 将模板`template`转化成`render`函数

- `core`  (核心模块 )

  - `components` 内置的组件
  - `global-api` 全局的`api`

  - `instance` `Vue`实例相关的核心逻辑 
  - `observer` `Vue`中`MVVM`响应式数据原理
  - `util`核心模块中的工具方法
  - `vdom` 虚拟`dom`模块

- `platform`(平台模块) 通过不同入口编译出不同的`vue.js`
  - `web` 浏览器中使用的`vue`
  - `weex `  `weex` 基于` vue `的移动端跨平台` ui`

- `server` 服务端渲染相关代码
- `sfc` 将`.vue` 文件编译成对象
- `shared` 所有模块中共享的方法

## 二.如何看`Vue`源代码

- 通过`package.json`来看项目入口
  - `main` 默认引入包会查找`main`对应的文件
  - `module` 如果使用`webpack`默认会以`module`对应的文件为入口

> 打包出的结果会放到`dist`目录下，我们需要查找打包的命令在哪里?

通过`scripts`的脚本来进行打包,找到`build`的相关字段

```bash
"build": "node scripts/build.js" 
"build:ssr": "npm run build -- web-runtime-cjs,web-server-renderer"
"build:weex": "npm run build -- weex"
```

核心打包执行的文件是`build.js`

**打包的模块类型**

模块的区别:`cjs`(`commonjs`规范) 、`es`(`es6Module`)、`umd` (`Universal Module Definition`  )  （包含`AMD`、`cmd`、` CommonJs `）



**分析打包流程**：

- 1.先查看`dist`目录是否存在,如果不存在就创建此目录

- 2.根据自己的配置生成`rollup`的配置

- 3.根据用户打包时传递的参数过滤配置

- 4.进行打包,并且生成打包后的结果写入到目录中

  

`Vue`的两种模式:`Runtime-Only` 不能在运行时编译模板只支持用户编写`render function`,`Runtime-with-Compiler`运行时可以编译模板文件体积大。



**找到`Vue`的入口**:

以`Runtime-with-Compiler`为入口 找到,`platform/web/entry-runtime-with-compiler`

分析入口查找:

- 1.先找到` entry-runtime-with-compliler `,重写`$mount`方法
- 2.找到` runtime/index ` 主要包含`$mount`核心方法 (`__patch__`方法
- 3.`core/index`在`Vue`的构造函数增加全局`api` 
- 4.` instance/index `找到`Vue`的构造函数,给`Vue`构造函数增加多个原型方法

![](C:\Users\test1\Desktop\vue源码剖析\constructor.png)

## 三.`Vue`的初始化工作

通过`demo`来找到真实引入的`Vue.js`文件 `vue/dist/vue.esm.js`

**分析初始化过程**:

- 1.`new Vue`时会调用`_init`方法
- 2.增加了`_uid`给每个实例增加唯一标识
- 3.将用户的所有属性挂载到`vm.$options`上
- 4.初始化状态 `initState()`将用户传递的属性挂载到`vm._data` 上并且代理到`vue`的实例上 

- 5.如果有`el`属性就进行挂载,并且调用`$mount`方法

**分析挂载流程**:

- 1.如果用户使用`runtime-with-compiler`会调用他内部的`$mount`方法

- 2.先判断是否有`render`方法,如果没有`render`会查找`template`并且将`template`变成`render`方法,如果没有`template`默认会使用`el`指定的`dom`元素

- 3.调用`runtime/index`中的`$mount`方法,内部会统一处理调用`mountComponent`

- 4.会校验`render`方法的存在,并且会将当前的真实`dom`挂载到`vm.$el`

- 5.生成`updateComponent`方法,并且初始化渲染`watcher`,内部会立刻调用`updateComponent`方法

  ```javascript
  vm._update(vm._render(), hydrating)
  ```

- 6.`vm._render`作用是返回`vnode`  内部会调用解析好的`render`方法(`vm._renderProxy` 和 `vm.$createElement`)

- `vm.$createElement` => `vdom/create-element` => `_createElement` =>` vnode`

- 7.`vm._update` 将`vnode` 渲染成真实的`dom`元素

  - `vm.__patch__` 默认会调用 `vdom/patch方法`
  - `patch`方法会根据`vm.$el`创建虚拟节点和新的节点,映射虚拟节点和新节点的关系
  - 递归创建子元素，将子元素插入到新的节点中。最终将新的节点插入到`vm.$el`的后面
  - 删除掉`vm.$el`对应的节点

## 四.数据响应式原理

将`data`对应的数据转化成采用`Object.defineProperty`来定义

- 1.会执行`initState`方法 => `initData` => `observe`
- 2.`new Observer` 收到要观察的数据 => `this.walk` => `defineReactive` => 如果观察对象的值是一个对象的话，会递归观察=> 采用`Object.defineProperty` 来重新定义属性
- 3.默认会先初始化`Watcher`实例，将此实例放到`Dep.target`上，并且给每一个属性增加一个`dep`属性,此`dep`会将当前的`Dep.target`存起来。
- 4.每次更新值都会通知对应`dep`中存放的`watcher` 让他们调用update方法最终会将要执行的`watcher`放到`queue`中，最后调用`nextTick(flushSchedulerQueue)`方法清空队列,让视图更新 

## 五.计算属性的实现

默认会创建一个计算属性`watcher`，当取值时会调用用户定义的计算属性方法,会对依赖的属性取值，此时依赖的属性会将计算属性的`watcher`收集起来,最后计算属性`watcher`会将渲染`watcher`放到对应的每个属性的`dep`中, 属性变化时会依次执行计算属性`watcher`和渲染`watcher`

## 六.`Watch`的实现原理

内部调用`vm.$watch`,默认会创建一个`watcher`,会将表达式根据`.`分割,去`vm`上取值，取值的过程中会将此`watcher`收集到当前属性的依赖中，属性变化会通知此`watcher`执行

## 七.`Dom-Diff`原理



## 下次预告

- vue核心基础 method/watch/computed 指令生命周期 动画

-  Vue组件间的属性传递

-  Vue组件的属性校验

- $emit方法

- v-model .sync的使用

-  跨级属性传递 Provide inject 父->子

- 跨级调用方法 $parent $children

-  实现broadcast dispatch

- $attrs $listeners

- ref的使用

- eventBus 和组件的声明周期

- slot的使用

- 表单组件

- 异步组件

- 递归组件

- 弹框组件

- render函数的使用*

- vue-lazyload