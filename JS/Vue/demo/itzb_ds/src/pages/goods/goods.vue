<template>
  <div class="goods">
    <Banner></Banner>
    <ProductDetail></ProductDetail>
  </div>
</template>

<script>
    import Banner from './Children/Banner'
    import ProductDetail from './Children/ProductDetail'

    export default {
        name: "goods",
        components: {
          Banner,
          ProductDetail
        },
        created(){
          this.$store.dispatch("requestProductDetail", this.$route.query.id)
        },
    }
</script>

<style scoped lang="less">

</style>
