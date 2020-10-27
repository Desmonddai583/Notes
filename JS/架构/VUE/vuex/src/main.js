import Vue from 'vue'
import App from './App.vue'
import store from './store' //  引入了一个store文件

Vue.config.productionTip = false

new Vue({
  name:'root',
  store, // 在vue初始化的过程中 注入了一个store属性, 内部会将这个属性放到每个组件的$store上
  render: h => h(App)
}).$mount('#app')


