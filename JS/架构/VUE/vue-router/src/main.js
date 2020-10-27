import Vue from 'vue'
import App from './App.vue'
import router from './router'

Vue.config.productionTip = false
new Vue({
  router, // 非常像 也是一个实例 所有的组件也都有这个router属性 
  render: h => h(App)
}).$mount('#app')
