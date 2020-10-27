// 1.导入默认样式
import '../static/css/reset.css'
import './assets/css/base.css'
// 2.导入处理移动端点击事件框架
import FastClick from 'fastclick'

import Vue from 'vue'
import App from './App'
// 导入路由对象
import router from './router'
// 导入Vuex对象
import store from  './store/index'
// 导入swiper框架
// import VueAwesomeSwiper from 'vue-awesome-swiper'
// import 'swiper/dist/css/swiper.css'
import { Header, Button } from 'mint-ui';

Vue.config.productionTip = false;

// 注册fastclick
FastClick.attach(document.body);
// 注册swiper
// Vue.use(VueAwesomeSwiper);
Vue.component(Button.name, Button);
Vue.component(Header.name, Header);

new Vue({
  el: '#app',
  // 注册路由对象
  router,
  // 注册vuex对象
  store,
  components: { App },
  template: '<App/>'
})
