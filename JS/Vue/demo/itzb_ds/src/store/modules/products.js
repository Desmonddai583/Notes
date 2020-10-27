export const DEFAULT_CART = "default_cart";
export const CHANGE_CHECK_ALL_STATE = "change_check_all_state";
export const CHANGE_CHECK_ITEM_STATE = "change_check_item_state";
export const CHANGE_PRODUCT_NUM = "change_product_num";
export const EDIT_PRODUCTS = "edit_products";
import {getCart, editCart} from './../../api/index'

const state = {
  // 存储购物车中所有的商品
  all:[],
  // 存储购物车全选状态
  checkAllState: false,
  // 存储每一个商品选中状态
  checkItemsState: [],
};

const mutations = {
  // 保存所有购物车中从网络获取到的数据
  [DEFAULT_CART](state, result){
    state.all = result.list;
    state.checkItemsState = state.all.map(function () {
      return false;
    });
  },
  // 修改全局选中状态
  [CHANGE_CHECK_ALL_STATE](state){
    // 1.修改全局的选中状态
    state.checkAllState = !state.checkAllState;
    // 2.修改每一个商品的选中状态
    state.checkItemsState.forEach(function (item, index) {
      state.checkItemsState.splice(index, 1, !item);
    })
  },
  // 修改某一个商品的选中状态
  [CHANGE_CHECK_ITEM_STATE](state, index){
    // 在vue中无法动态的监听到数组元素和对象属性的变化
    // 如果想让vue监听到数组元素或者对象属性的变化,
    // 那么可以使用vue.$set设置值 或者可以使用数组的splice
    // state.checkItemsState[index] = !state.checkItemsState[index];
    // 1.修改当前商品的选中状态
    state.checkItemsState.splice(index, 1, !state.checkItemsState[index]);
    // 2.检查全局选中状态
    let result = state.checkItemsState.find(function (item, index) {
      return item === false;
    });
    state.checkAllState = result !== false;
  },
  // 修改某一个商品的数量
  [CHANGE_PRODUCT_NUM](state, obj){
    let product = state.all[obj.index];
    if(obj.type === 'sub'){
      product.num = product.num - 1;
    }else{
      product.num = product.num + 1;
    }
  },
};

const actions = {
  // 1.获取全局购物车数据
  async requestCart({commit}){
    // 从服务器获取数据
    const result = await getCart();
    // 进行安全校验
    if(result.code === 0){
      // 告诉mutations将数据保存起来
      commit(DEFAULT_CART, result.data);
    }else{
      console.log("获取全局底部工具条数据失败");
    }
  },
  // 2.修改全局购物车全选状态
  changeCheckAllState({commit}){
    commit(CHANGE_CHECK_ALL_STATE);
  },
  // 3.修改全局购物车某一个商品选中状态
  changeCheckItemState({commit}, index){
    commit(CHANGE_CHECK_ITEM_STATE, index);
  },
  // 4.修改商品的数量
  changeProductNum({commit}, obj){
    commit(CHANGE_PRODUCT_NUM, obj);
  },
  // 5.保存用户修改之后的商品
  async editProducts({commit}){
    let result = await editCart({
      list: state.all,
      access_token: "7apWBXl1llqEKJUlQ2_qHaptxbeZ5zeu"
    });
    if(result.code === 0){
      console.log("保存购物车数据成功");
    }else{
      console.log("保存购物车数据失败");
    }
  }
};
const getters = {
  totalPrice(state){
    let total = 0;
    state.checkItemsState.forEach(function (value, index) {
      if(value === true){
        let product = state.all[index];
        total += product.num * product.price;
      }
    });
    return total;
  }
};

export default {
  namespaced: true,
  state,
  mutations,
  actions,
  getters,
}

