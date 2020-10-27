<template>
    <div class="product-detail">
        <div class="detail-top">
          <div
            tag="div"
            class="detail-info"
            @click="switchTo('/pages/goods/goods/detail')">商品详情</div>
          <div
            tag="div"
            class="detail-common"
            @click="switchTo('/pages/goods/goods/common')">评价</div>
        </div>
      <router-view></router-view>
    </div>
</template>

<script>
    export default {
        name: "ProductDetail",
        methods: {
          switchTo(path){
            this.$router.replace(path);
          }
        }
    }
</script>

<style scoped lang="less">
  .product-detail{
    margin-top: 20px;
    .detail-top{
      width: 100%;
      height: 100px;
      line-height: 100px;
      display: flex;
      align-items: center;
      background: #fff;
      div{
        flex: 1;
        text-align: center;
        font-size: 30px;
      }
    }
  }
</style>
