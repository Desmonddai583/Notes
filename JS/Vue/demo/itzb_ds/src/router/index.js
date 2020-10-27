// 1.导入Vue和Vue路由
import Vue from 'vue'
import Router from 'vue-router'

// 导入路由相关的组件
import index from './../pages/index/index'
import cat from './../pages/cat/cat'
import cart from './../pages/cart/cart'
import user from './../pages/user/user'
import goods from './../pages/goods/goods'
import detail from './../pages/goods/Children/Detail'
import common from './../pages/goods/Children/Common'

// 2.声明在Vue中使用路由
Vue.use(Router);

// 3.对外暴露一个路由对象
export default new Router({
  routes: [
    {path: '/pages/index/index', component: index},
    {path: '/pages/cat/cat', component: cat},
    {path: '/pages/cart/cart', component: cart},
    {path: '/pages/user/user', component: user},
    {
      path: '/pages/goods/goods',
      component: goods,
      children: [
        /*注意点: 子路由的path前面不用加/
        * 会自动匹配/onepage/sub1page
        * */
        { path: 'detail', component: detail },
        { path: 'common', component: common },
        {path: '/pages/goods/goods', redirect: '/pages/goods/goods/detail'},
      ]
    },
    {path: '/', redirect: '/pages/index/index'},
  ]
})
