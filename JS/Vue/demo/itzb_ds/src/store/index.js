// 本文件是Vuex要求的基本结构, 别忘记注册到VM中
// 1.导入对应的包
import Vue from 'vue'
import Vuex from 'vuex'

import state from './state'
import mutations from './mutations'
import actions from './actions'
import getters from './getters'

// 导入独立的Store模块
import products from './modules/products'

// 2.声明需要使用Vuex
Vue.use(Vuex);

// 3.对外暴露一个Vuex的store对象
export default new Vuex.Store({
  state,
  mutations,
  actions,
  getters,
  modules: {
    products
  }
});
