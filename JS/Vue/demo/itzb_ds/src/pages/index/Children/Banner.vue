<template>
  <swiper :options="swiperOption" ref="mySwiper" v-if="bannerlist">
      <swiper-slide v-for="(item, index) in bannerlist" :key="index">
        <a :href="item.page_url">
          <img :src="item.pic_url"/>
        </a>
      </swiper-slide>

    <!-- 如果需要分页器 -->
    <div class="swiper-pagination" slot="pagination"></div>
  </swiper>
</template>

<script>
  /*
  1.vue-awesome-swiper使用
  vue-awesome-swiper是基于swiper4封装的一套vue组件, 解决了原生swiper在vue中使用的一些常见bug

  1.1npm install vue-awesome-swiper --save
  1.2全局导入
  import VueAwesomeSwiper from 'vue-awesome-swiper'
  import 'swiper/dist/css/swiper.css'
  Vue.use(VueAwesomeSwiper)
  1.3局部导入
  import 'swiper/dist/css/swiper.css'
  import { swiper, swiperSlide } from 'vue-awesome-swiper'
  还必须将swiper和swiperSlide注册当前组件的子组件
  1.4使用
  <swiper :options="swiperOption">
       <swiper-slide>I'm Slide 1</swiper-slide>
  </swiper>
  注意点:
  swiperOption: 必须通过组件的data返回, 对应的数据都是swiper4中的属性
  其它的辅助空间都必须加上slot,
  例如:
  <div class="swiper-pagination"  slot="pagination"></div>
  如果同一个界面中出现了多个swiper, 只要swiper的:options不同就不会相互影响
  */
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
        computed:{
            bannerlist(){
              return this.$store.state.homeInfo.banner_list;
            },
            swiper() {
              return this.$refs.mySwiper.swiper
            }
        }
    }
</script>

<style scoped lang="less">

</style>
<!--swiper4无法在scoped的style中覆盖样式, 如果需要覆盖swiper4中的样式, 需要另外写一个不带scoped的style标签-->
<style>
  .swiper-pagination-bullet {
    background: transparent;
    border: 2px solid #fff;
  }
  .swiper-pagination-bullet-active{
    background: #fff;
  }
</style>
