<template>
  <div class="detail-top">
    <swiper :options="swiperOption" ref="mySwiper" v-if="productinfo">
      <swiper-slide v-for="(item, index) in productinfo.pic_list" :key="index">
        <img :src="item.pic_url"/>
      </swiper-slide>
      <!-- 如果需要分页器 -->
      <div class="swiper-pagination" slot="pagination"></div>
    </swiper>
   <div class="banner-title">
     <p class="gd-name">{{productinfo.name}}</p>
     <p class="gd-price">{{productinfo.price}}</p>
     <p>
       <del class="gd-original-price">{{productinfo.original_price}}</del>
       <span class="gd-sales">销售量: {{productinfo.sales}} 件</span>
     </p>
   </div>
  </div>



</template>

<script>
  import {mapState} from 'vuex'
  import 'swiper/dist/css/swiper.css'
  import { swiper, swiperSlide } from 'vue-awesome-swiper'

    export default {
        name: "Banner",
        components: {
          swiper,
          swiperSlide
        },
        data(){
          return {
            swiperOption: {
              loop: true, // 循环模式选项
              autoplay: {
                delay: 1000, //自动切换的时间间隔，单位ms
                stopOnLastSlide: false, //当切换到最后一个slide时停止自动切换
                disableOnInteraction: false, //用户操作swiper之后，是否禁止autoplay。
              },
              // 如果需要分页器
              pagination: {
                el: '.swiper-pagination',
              },
              observer:true,
              observeParents:true,
            }
          }
        },
        computed: mapState(['productinfo']),
    }
</script>

<style scoped lang="less">
  .detail-top{
    background: #fff;
    padding-bottom: 35px;
    .banner-title{
      padding: 0 15px;
      box-sizing: border-box;
      .gd-name{
        font-size: 35px;
      }
      .gd-price{
        font-size: 35px;
        color: orangered;
        line-height: 80px;
        &::before{
          font-family: "iconfont";
          font-style: normal;
          font-size: 40px;
          content: "\eb1e";
        }
      }
      .gd-original-price{
        font-size: 20px;
        &::before{
          font-family: "iconfont";
          font-style: normal;
          font-size: 40px;
          content: "\eb1e";
        }
      }
      .gd-sales{
        font-size: 20px;
      }
    }


  }
</style>
