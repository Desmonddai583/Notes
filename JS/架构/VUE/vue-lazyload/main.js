// vue-lazyload 图片懒加载 v-lazy
import Vue from 'vue';
import VuelazyLoad from './vue-lazyload';
import loading from './loading.jpg'
import App from './App.vue'
// use方法是一个全局的api 会调用 VuelazyLoad install
Vue.use(VuelazyLoad,{
    preLoad: 1.3, // 可见区域的1.3倍
    loading, // loading图
}); // use的默认调用就会执行VuelazyLoad的install方法

let vm = new Vue({
    el:'#app',
    render:h=>h(App)
})