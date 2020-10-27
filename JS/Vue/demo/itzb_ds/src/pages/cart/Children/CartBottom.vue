<template>
    <div class="cart-bottom">
        <div class="bottom-left">
          <a href="javascript:;" class="iconfont" @click="checkall">{{checkAllState ? '&#xe604;' : '&#xe651;'}}</a>
          <span>全选</span>
          <span class="total-price">总计: {{totalPrice}}</span>
        </div>
      <div class="bottom-right">
        <button class="edit-btn">编辑</button>
        <button class="sale-btn">结算</button>
      </div>
    </div>
</template>

<script>
    import {mapState, mapGetters} from 'vuex'

    export default {
        name: "CartBottom",
        methods: {
          checkall(){
            this.$store.dispatch("products/changeCheckAllState");
          }
        },
        computed: {
          ...mapState("products", ['checkAllState']),
          ...mapGetters("products", ['totalPrice'])
        }
    }
</script>

<style scoped lang="less">
  .cart-bottom{
    width: 100%;
    height: 100px;
    display: flex;
    justify-content: space-between;
    align-items: center;

    position: fixed;
    bottom: 115px;
    left: 50%;
    transform: translateX(-50%);
    background: #fff;
    .bottom-left{
        a{
          font-size: 30px;
          margin: 0 25px;
        }
        span{
          font-size: 30px;
        }
        .total-price{
          color: orangered;
        }
    }
    .bottom-right{
      height: 100%;
      button{
        border: none;
        outline: none;
        width: 160px;
        height: 100%;
        font-size: 30px;
        color: #fff;
        float: left;
      }
      .edit-btn{
        background: #3c8bea;
      }
      .sale-btn{
        background: #fd4344;
      }
    }
  }
</style>
