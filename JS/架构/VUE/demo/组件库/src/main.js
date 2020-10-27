import Vue from 'vue'
import App from './App.vue'

Vue.config.productionTip = false

// 引入我们的组件库
import zhuUi from './packages/index'
Vue.use(zhuUi); // Vue.use zhuUi.install

new Vue({
  render: h => h(App),
}).$mount('#app')
