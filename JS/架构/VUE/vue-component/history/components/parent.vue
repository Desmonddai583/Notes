<template>
    <div>
        parent
        <!-- 方式1 -->
        <!-- <Son1 :money="mny" :change-money="changeMoney"></Son1> -->

        <!-- 方式二 给儿子添加一个事件 ，等一会触发这个事件 -->
        <!-- v-on:click="changeMoney"   son1.$on('click',changeMoney)  son1.$emit('click',100) -->
        <!-- click不是原生的事件 .native修饰符 会把事件绑定给 当前的组件的最外层元素上 -->
        <!-- <Son1 :money="mny" @a="changeMoney"></Son1> -->


        <!-- 同步数据 -->
        <!-- {{mny}} -->
        <!-- <Son1 :value="mny" @input="val=>mny=val"></Son1> -->
        <!-- 可以更换成  是 value+input的语法糖-->
        <!-- <Son1 v-model="mny"></Son1> -->

        <!--  如何自定义v-model  value + input的语法糖  -->
        <!-- <Son1 v-model="mny"></Son1> -->

        <!-- .sync语法 语法糖 -->
        <!-- <Son1 :money="mny" @update:money="val=>mny=val"></Son1>
        <Son1 :money.sync="mny" ></Son1> -->

        <!-- 如果父子组件 想同步数据 可以使用 传递属性+自定义事件的方式 （语法糖 v-model/.sync） -->
        <!-- 将父组件的方法直接传递给子组件调用 -->
        {{mny}} 
        <Son2 @eat="eat"></Son2>
    </div>
</template>

<script>
import Son1 from './son1';
import Son2 from './son2';
export default {
    provide(){ // 提供者 上下文
        return {parent:this} // 直接将这个组件暴露出去
    },
    name:'parent',
    components:{
        Son1,
        Son2
    },
    data(){ // 父亲有100块
        return {mny:100}
    },
    methods:{
        changeMoney(value){ // methods中的函数 已经被bind过了 
            this.mny += value;
        },
        eat(){
            console.log('son2 绑定的eat')
        }
    }
}

// 数据传递的关系  父子传递  字父传递 平级通信 跨级通信
</script>