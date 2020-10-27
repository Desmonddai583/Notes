import Vue from 'vue';
import App from './App.vue';
import createRouter from './router';
import createStore from './store'
export default function () { // 服务端需要  客户端也需要
    let router = createRouter();
    let store = createStore();
    let app = new Vue({
        store,
        router, // 前端直接注入即可
        render:h=>h(App)
    });
    return {app,router,store}
}


// 服务端渲染需要一个vm实例
// 假如只有一个vm实例，每一个客户端访问我 都要有一个全新的实例
// 将new Vue这个代码包装成一个函数 每次服务端渲染的时候 都通过函数返回实例的来渲染
// data(){}