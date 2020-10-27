import Vue from 'vue';
import Vuex from 'vuex';

Vue.use(Vuex);
import axios from 'axios';
import {authRoutes} from './router';
// addRoutes
const getRoutes = (authList)=>{
    let auths = authList.map(item=>item.auth);
    const filter = (authRoutes) =>{
        let result = authRoutes.filter(route=>{
            if(auths.includes(route.name)){
                if(route.children){
                    route.children = filter(route.children);
                }
                return route;
            }
        })
        return result
    }
    let r =  filter(authRoutes);
    return r
}
export default new Vuex.Store({
    // 第一次加载页面时 获取权限 之后在切换时就不用获取权限了
    state:{
        hasPermission:false,
        authList:[],
        btnPermission:{
            edit:true,
            add:true
        }
    },
    mutations:{
        setPermission(state){
            state.hasPermission = true;
        },
        setAuthList(state,list){
            state.authList = list
        }
    },
    actions:{
        async getMenuList({commit}){
            let {data} = await axios.get('http://localhost:3000/category');
            let r = data.menuList.map(item=>({name:item.name,auth:item.auth}));
            commit('setAuthList',r);
            commit('setPermission');
            return r;
        },
        async getAuthRoutes({dispatch}){ // action 可以调用另一个action
            // 获取菜单的列表
            let authList = await dispatch('getMenuList');
            // 需要通过权限路由 筛选出当前需要用到的路由 动态的添加一下
            return getRoutes(authList);
        }
    }
}); 