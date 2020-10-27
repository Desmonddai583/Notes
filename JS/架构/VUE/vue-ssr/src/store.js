import Vue from 'vue';

import Vuex from 'vuex';

Vue.use(Vuex);


export default ()=>{
    let store = new Vuex.Store({
        state:{
            name:''
        },
        mutations:{
            changeName(state){
                state.name = 'zf';
            }
        },
        actions:{
            changeName({commit}){ // 模拟的数据请求 axios
                return new Promise((resolve,reject)=>{
                    setTimeout(() => {
                        commit('changeName')
                        resolve();
                    }, 5000);
                })
            }
        }
    });
    if(typeof window !== "undefined"){ // 服务环境没有window属性 只有客户端具备window属性
        if(window.__INITIAL_STATE__){
            store.replaceState(window.__INITIAL_STATE__)
        }
    }
    return store;
}