import Vue from 'vue'
import Vuex from './vuex'

Vue.use(Vuex) // 默认会执行当前插件的install方法

// 通过 Vue中的一个属性 Store 创建一个store的实例
function logger(store){
    let prevState = JSON.stringify(store.state) // 默认状态
    store.subscribe((mutation,newState)=>{ // 每次调用mutation 此方法就会执行
      console.log(prevState);
      console.log(mutation);
      console.log(JSON.stringify(newState));
      prevState = JSON.stringify(newState); // 将当前的最新状态保存下来
    })
    
}
function persists(store){ // 每次去服务器上拉去最新的 session、local
  let local = localStorage.getItem('VUEX:state');
  if(local){
    store.replaceState(JSON.parse(local)); // 会用local替换掉所有的状态
  }
  store.subscribe((mutation,state)=>{
    // 这里需要做一个节流  throttle lodash
    localStorage.setItem('VUEX:state',JSON.stringify(state));
  });
}
let store =  new Vuex.Store({
  strict:true,
  plugins:[
    persists
    // logger 
    // vue-persists 可以实现vuex 的数据持久化
    // createLogger() // 我每次提交的时候 希望看下 当前的状态的变化
  ],
  modules:{
    a:{
      namespaced:true, // 表示给a 盖了一房子
      state:{
        age:'a100',
      },
      mutations:{
        syncChange(){
          console.log('a-syncChange')
        }
      }
    },
    b:{
      namespaced:true,
      state:{
        age:'b100',
      },
      mutations:{
        syncChange(){
          console.log('b-syncChange')
        }
      },
      modules:{
        c:{
          namespaced:true, 
          state:{
            age:'c100'
          },
          mutations:{
            syncChange(){
              console.log('c-syncChange')
            }
          }
        }
      }
    }
  },
  state: {// 单一数据源  data
    age:10
  },
  getters:{ // computed
    myAge(state){ // 以前用vue中的计算属性
      return state.age + 20
    }
  },
  // 更新状态的唯一方式就是通过mutation
  mutations: { // mutation更改状态只能采用同步（严格模式下使用）  // method
    // payload 载荷
    syncChange(state,payload){ // 修改状态的方法 同步的更改
      setTimeout(() => {
      state.age += payload
      }, 1000);
    }
  },
  actions: {
    asyncChange({commit},payload){
      setTimeout(() => {
        commit('syncChange',payload)
      }, 1000);
    }
  }
})
// 就是在我们格式化后的树中进行格式化操作
// 在将当前模块进行安装
store.registerModule(['b','d'],{
  state:{
    age:'d100'
  }
})
export default store