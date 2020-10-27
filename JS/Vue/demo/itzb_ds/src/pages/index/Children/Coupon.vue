<template>
  <div class="coupon">
    <div class="coupon-header clearfix">
      <div class="coupon-title f-left">
        <span class="iconfont">&#xe610;</span>
        <span>专享优惠券</span>
      </div>
      <div class="coupon-more f-right">
        <span>更多</span>
        <span class="iconfont">&#xe64e;</span>
      </div>
    </div>
    <div class="coupon-footer">
      <ul v-if="couponinfo && updatelist" ref="cp">
        <li v-for="(item, index) in couponinfo" :key="index" ref="cpitem">
          <img :src="updatelist.coupon.bg">
          <span>{{item.sub_price}}</span>
          <span>满{{item.min_price}}元可用</span>
          <span>立即领取</span>
        </li>
      </ul>
    </div>
  </div>
</template>

<script>
    export default {
        name: "Coupon",
        computed:{
            couponinfo(){
              return this.$store.state.homeInfo.coupon_list;
            },
            updatelist(){
              return this.$store.state.homeInfo.update_list;
            }
        },
        mounted(){
          this.$nextTick(function () {
            if(this.$refs.cpitem.length > 0){
              let cpitem = this.$refs.cpitem;
              let cp = this.$refs.cp;
              let width = cpitem.length * cpitem[0].offsetWidth;
              cp.style.width = width + "px";
            }
          });
        },
        watch: {
            "couponinfo":function () {
              // this.$nextTick(function () {
              //   if(this.$refs.cpitem.length > 0){
              //     let cpitem = this.$refs.cpitem;
              //     let cp = this.$refs.cp;
              //     let width = cpitem.length * cpitem[0].offsetWidth;
              //     cp.style.width = width + "px";
              //   }
              // });
            }
        }
    }
</script>

<style scoped lang="less">
  .coupon {
    width: 100%;
    margin-top: 10px;
    overflow: hidden;
    .coupon-header {
      height: 80px;
      line-height: 80px;
      background: #fff;
      padding: 0 15px;
      box-sizing: border-box;
      font-size: 30px;
      color: #666;
      .coupon-title {
        span:nth-child(1) {
          font-size: 40px;
          color: orangered;
          margin-right: 15px;
        }
      }
      .coupon-more {
        span:nth-child(2) {
          font-size: 35px;
          vertical-align: middle;
        }
      }
    }
    .coupon-footer{
      margin-top: 1px;
      background: #fff;
      overflow-x: scroll;
      &::-webkit-scrollbar{
        display: none;
      }
      ul{
        list-style: none;
        li{
          float: left;
          width: 260px;
          height: 130px;
          padding: 20px;
          position: relative;
          span{
            position: absolute;
            color: #fff;
            font-size: 20px;
            &:nth-of-type(1){
              font-size: 40px;
              left: 60px;
              top: 40px;
              &::before{
                font-family: "iconfont";
                font-style: normal;
                font-size: 40px;
                content: "\eb1e";
              }
            }
            &:nth-of-type(2){
              font-size: 40px;
              transform: scale(0.5);
              -webkit-text-size-adjust: none;
              white-space: nowrap;
              left: 0px;
              bottom: 15px;
            }
            &:nth-of-type(3){
              font-size: 40px;
              transform: scale(0.5);
              width: 20px;
              right: 45px;
              top: -10px;
            }
          }
        }
      }
    }
  }
</style>
