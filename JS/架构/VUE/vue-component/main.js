import Vue from 'vue';
import App from './App';
// 绑定事件和触发事件 需要在同一个实例上
// Vue.prototype.$bus = new Vue(); // 每个vue实例都具备这$on $emit $off 
let vm = new Vue({
    el:'#app',
    render:h=>h(App)
});

// vm.$bus.$emit('监听事件','根实例')
// 组件间的数据传递 属性 $emit
// 同步数据 .sync  v-model 语法糖
// Provide inject 自己写的库中来使用

// $parent $children => $broadcast  $dispatch
// $attrs $listeners

// ref 操作dom元素 也可以给组件添加ref 可以获取组件的实例

// 如果是兄弟组件间获取数据 找到兄弟的共同父亲来通信
// eventBus 事件车 发布订阅模式 在任何组件中订阅 ，在其他组件中触发事件

// 子组件如何监听父组件的mounted事件？
// 组件挂载 是先挂载父组件-》渲染子组件-》子mounted -> 父mounted

// eventBus 可以任意组件间通信 只适合小规模的 通信 (大规模会导致事件不好维护 一呼百应)
// vuex