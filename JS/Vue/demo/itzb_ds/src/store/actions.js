// 本文件是Vuex中专门用于组件修改State中的数据, 或者从网络获取数据使用的
// 1.引入网络请求API
import {
  getNavbar,
  getHome,
  getCat,
  getUser,
  getProductDetail
} from './../api/index'
// 2.引入方法名称常量
import {
  DEFAULT_NAVBAR,
  DEFAULT_HOME,
  DEFAULT_CAT,
  DEFAULT_USER,
  PRODUCT_DETAIL} from './mutations-type'

export default {
  // 1.获取全局底部工具条数据
  async requestNavbar({commit}){
     // 从服务器获取数据
     const result = await getNavbar();
     // 进行安全校验
    if(result.code === 0){
      // 告诉mutations将数据保存起来
       commit(DEFAULT_NAVBAR, result.data);
    }else{
      console.log("获取全局底部工具条数据失败");
    }
  },
  // 1.获取全局首页数据
  async requestHome({commit}){
    // 从服务器获取数据
    const result = await getHome();
    // 进行安全校验
    if(result.code === 0){
      // 告诉mutations将数据保存起来
      commit(DEFAULT_HOME, result.data);
    }else{
      console.log("获取全局底部工具条数据失败");
    }
  },
  // 1.获取全局底部工具条数据
  async requestCat({commit}){
    // 从服务器获取数据
    const result = await getCat();
    // 进行安全校验
    if(result.code === 0){
      // 告诉mutations将数据保存起来
      commit(DEFAULT_CAT, result.data);
    }else{
      console.log("获取全局底部工具条数据失败");
    }
  },
  // 1.获取全局底部工具条数据
  async requestUser({commit}){
    // 从服务器获取数据
    const result = await getUser();
    // 进行安全校验
    if(result.code === 0){
      // 告诉mutations将数据保存起来
      commit(DEFAULT_USER, result.data);
    }else{
      console.log("获取全局底部工具条数据失败");
    }
  },

  // 1.获取全局底部工具条数据
  async requestProductDetail({commit}, id){
    // 从服务器获取数据
    const result = await getProductDetail(id);
    // 进行安全校验
    if(result.code === 0){
      // 告诉mutations将数据保存起来
      commit(PRODUCT_DETAIL, result.data);
    }else{
      console.log("获取全局底部工具条数据失败");
    }
  },
}
