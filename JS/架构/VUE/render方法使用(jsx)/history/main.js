import Vue from 'vue';
import App from './App';


// render方法 =》 jsx javascript + xml 可以实现更灵活的写法
new Vue({
    el:'#app',
    render:h=>h(App)
})