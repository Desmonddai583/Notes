import Vue from 'vue';
import MessageComponent from './message.vue';


let MessageConstructor = Vue.extend(MessageComponent);
const Message = (options) =>{
    // 统一的入口
    let instance = new MessageConstructor({ // 给这个组件传入了data数据
        data:options
    });
    instance.$mount(); // 表示挂载组件 这个挂载后的结果会放到 instance.$el;
    document.body.appendChild(instance.$el);
    instance.visible = true; // 扔到页面时 将属性visible改成true
}
['success','error','warning'].forEach(type=>{
    Message[type] = function (options) {
        options.type = type;
        return Message(options)
    }
})

export {Message}