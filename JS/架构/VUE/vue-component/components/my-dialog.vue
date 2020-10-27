<template>

    <div v-if="isShow">
        <div><slot name="header"></slot></div>
        这是一个弹框
        <div><slot name="footer" :isShow="isShow" a="a" b="b" ></slot></div>
    </div>
</template>

<script>
export default {
    data(){
        return {isShow:true}
    },
    mounted(){
        // {'监听事件',[fn,fn]}
        this.fn = function (arg) {
           console.log(arg);
        }
        this.$bus.$on('监听事件',this.fn);
        this.$nextTick(()=>{
             this.$bus.$emit('父')
        })
        
    },  
    methods:{
        change(){
            this.isShow = !this.isShow
        }
    },
    beforeDestroy(){
        this.$bus.$off('监听事件'); // 移除事件
    }
}
</script>