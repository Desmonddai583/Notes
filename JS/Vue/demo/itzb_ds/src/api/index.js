// 外界通过调用api文件夹中的index.js中的一些方法就或从网络获取数据
// 1.导入封装好的网络请求工具类
import http from './ajax'

// 2.封装不同API请求的函数
// 2.1获取全局底部工具条数据
// export const getNavbar = function () {
//   return http.get("default/navbar")
// };
export const getNavbar = () => http.get("default/navbar");

// 2.2获取首页数据
export const getHome = () => http.get("default/index");

// 2.3获取分类数据
export const getCat = () => http.get("default/cat-list");

// 2.4获取购物车数据
export const getCart = () => http.get("cart/list&access_token=7apWBXl1llqEKJUlQ2_qHaptxbeZ5zeu");

// 2.5保存用户修改之后的购物车数据
export const editCart = (data) => http.post("cart/cart-edit", data);

// 2.5获取个人中心数据
export const getUser = () => http.get("user/index&access_token=7apWBXl1llqEKJUlQ2_qHaptxbeZ5zeu");

// 2.6获取商品详情数据
export const getProductDetail = (goodsid) => http.get('default/goods', {
    id: goodsid,
    access_token: '7apWBXl1llqEKJUlQ2_qHaptxbeZ5zeu'
  });
