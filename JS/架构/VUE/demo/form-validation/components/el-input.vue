<template>
    <input type="text" :value="value" @input="handleInput">
</template>

<script>
export default {
    name:'el-input',
    props:{
        value:String
    },
    methods:{
        handleInput(e){
            this.$emit('input',e.target.value);

            let parent = this.$parent; // 这里的父亲不一定就是el-form-item;
            while(parent){
                let name = parent.$options.name;
                if(name === 'el-form-item'){
                    break;
                }else{
                    parent = parent.$parent; // 一直找父亲
                }
            }
            if(parent){
                 parent.$emit('validate')
            }
        }
    }
}
</script>