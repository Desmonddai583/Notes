import Vue from 'vue'
import App from './App.vue'
import router from './router'
import store from './vuex';
Vue.config.productionTip = false;


Vue.directive('has',{
  inserted(el,bindings,vnode){
    let permission = bindings.value;
    let r = vnode.context.$store.state.btnPermission[permission];
    !r && el.parentNode.removeChild(el);
  }
})
router.beforeEach(async (to,from,next)=>{
  if(!store.state.hasPermission){ // 根据vuex 的状态 来获取结果
     // 没有从后台中拉取过权限
     let needRoutes = await store.dispatch('getAuthRoutes'); // 获取权限路由
     router.addRoutes(needRoutes); // 这里添加路由之后 路由不会立即生效,而是下次才生效

     // 刚添加好路由就访问它
     // next如果传入的是一个对象话 {path:/} 会跳转到路径上
     console.log('1')
     next({...to,replace:true}); // hack 不记录历史 replaceState
     
  }else{
    console.log('2')

    next(); // 是否向下执行
  }
})
new Vue({
  router,
  store,
  render: h => h(App)
}).$mount('#app')
