import Vue from 'vue';
import App from './App.vue';
// 默认使用的是runtime-only

// 向上派发事件 只要组件上绑定过此事件就会触发
// 我想将这个方法 指定到特定组件上
Vue.prototype.$dispatch = function (eventName,componentName,value) {
    let parent = this.$parent;
    while (parent) {
        // 触发指定组件的事件  而不是全部向上找
        if(parent.$options.name ===componentName ){
            parent.$emit(eventName,value); // 没有绑定触发 不会有任何影响
            return
        }
        parent = parent.$parent
    }
}
// 向下通知某个组件 进行触发事件
Vue.prototype.$broadcast = function (eventName,componentName,value) {
    // 需要找到所有儿子组件进行触发
    let children = this.$children; // 获取的是数组
    function broadcast(children){
        for(let i = 0; i < children.length ; i++){
            let child = children[i];
            if(componentName === child.$options.name){ // 找到了同名组件
                child.$emit(eventName,value);
                return;
            }else{
                if(child.$children){
                    broadcast(child.$children);
                }
            }
        }
    }
    broadcast(children);
}
new Vue({
    el:'#app', // 内部自带html模板
    render:h=>h(App),
})


// 组件间的通信
// v-loader => .vue vue-template-compiler 来实现的
// 编译时 将template变成render函数

// 默认的配置就是vue-cli的配置