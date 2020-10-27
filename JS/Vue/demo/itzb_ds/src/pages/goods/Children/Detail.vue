<template>
    <div v-if="detail">
      <div v-html="detail"></div>
    </div>
</template>

<script>
    export default {
        name: "Detail",
        computed:{
          detail(){
            return this.$store.state.productinfo.detail;
          }
        }
    }
</script>

<style scoped lang="less">

</style>
