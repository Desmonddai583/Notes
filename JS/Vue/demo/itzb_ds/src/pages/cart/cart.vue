<template>
  <div class="cart">
    <Header>
      <p slot="center">购物车</p>
    </Header>
    <CartList></CartList>
    <CartBottom></CartBottom>
  </div>
</template>

<script>
    import Header from '@/components/Header/Header'
    import CartList from './Children/CartList'
    import CartBottom from './Children/CartBottom'

    export default {
        name: "cart",
        components: {
          Header,
          CartList,
          CartBottom
        },
        created(){
          this.$store.dispatch("products/requestCart");
        },
        beforeDestroy(){
          // 当用户离开购物车界面的时候, 需要保存用户修改之后的购物车数据
          this.$store.dispatch("products/editProducts");
        }
    }
</script>

<style scoped lang="less">
  .cart{
    width: 100%;
    background: #fff;
    padding-bottom: 215px;
    box-sizing: border-box;
  }
</style>
