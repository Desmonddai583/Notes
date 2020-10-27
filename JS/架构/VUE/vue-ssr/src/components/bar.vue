<template>
    <div>
        bar  {{$store.state.name}}
    </div>
</template>
<script>
export default {
    mounted(){ // mounted 服务端不会触发此逻辑 因为服务端没有dom结构
        this.$store.dispatch('changeName')
    },
    // ssr 只有首屏 如果已经运行起来了 后续逻辑 都是单页应用里的
    asyncData(store){ // 规定这个方法可以在后端执行 (只能在页面级组件使用)
        return store.dispatch('changeName');
    }
}
</script>
<style scoped>
div{
    background: red
}
</style>