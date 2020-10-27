<template>
    <div>
        <!-- son1  {{value}} -->
        <!-- 方式1 -->
        <!--  <button @click="changeMoney(500)">更改父亲的钱数</button> -->
        <!-- 方式2 -->
        <!-- <button @click="change">点击按钮</button> -->
        <!-- 方式3 -->
        <!-- <button @click="change1">点击按钮</button> -->

        <!-- son1 {{mny}}  <button @click="$emit('change',500)">更新</button>
         -->

         {{money}}  <button @click="$emit('update:money',500)">点击更新</button>
    </div>
</template>

<script>
export default {
    model:{
        prop:'mny', // 默认是 value属性
        event:'change' // 默认事件名叫input
    },
    name:'son1',
    // 把money属性添加给了子组件
    // 子组件不能更改父组件中的数据，因为属性不是响应式
    // 子组件可以调用父组件中定义的函数，将需要修改的值传递给父组件。典型的单向数据流
    props:{
        mny:{
            type:Number
        },
        value:{
            type:Number,
        },
        money:{
            type:Number,
            default:100
        },
        changeMoney:{
            type:Function,
            default:()=>{}
        }
    },
    methods:{
        change(){
            this.$emit('a',300);
        },
        change1(){
            this.$emit('input',300)
        }
    }
}
</script>