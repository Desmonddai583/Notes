import Vue from 'vue';
let vm = new Vue({
    el:'#app',
    data(){
        return {msg:'hello zf'}
    },
    render(h){ // 内部会调用此render方法 将render方法中的this 变成当前实例
        return h('p',{id:'a'},this.msg)
    }
})
setTimeout(() => {
    vm.msg = 'hello world'
}, 1000);