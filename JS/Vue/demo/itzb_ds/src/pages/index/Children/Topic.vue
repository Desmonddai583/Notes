<template>
    <div class="topic">
      <div class="topic-left f-left" v-if="updatelist">
        <img :src="updatelist.topic.logo_1" alt="">
      </div>
      <div class="topic-rigtht">
        <swiper :options="topicOption" v-if="topiclist">
            <swiper-slide v-for="(item, index) in topiclist" :key="index">
              <img :src="updatelist.topic.heated" alt="">
              <span v-for="(v, i) in item">{{v.title}}</span>
            </swiper-slide>
        </swiper>
      </div>
    </div>
</template>

<script>
    import 'swiper/dist/css/swiper.css'
    import { swiper, swiperSlide } from 'vue-awesome-swiper'

    export default {
        name: "Topic",
        components: {
          swiper,
          swiperSlide
        },
        data(){
          return {
            topicOption: {
              direction : 'vertical',
              loop: true, // 循环模式选项
              autoplay: true,
              observer:true,
              observeParents:true,
            }
          }
        },
        computed: {
          topiclist(){
            return this.$store.state.homeInfo.topic_list;
          },
          updatelist(){
            return this.$store.state.homeInfo.update_list;
          }
        }
    }
</script>

<style scoped lang="less">
  .topic{
    width: 100%;
    height: 80px;
    line-height: 80px;
    background: #fff;
    padding: 0 15px;
    box-sizing: border-box;
    overflow: hidden;
    .topic-left{
      margin-right: 15px;
      img{
        width: 105px;
        vertical-align: middle;
      }
    }
    .topic-rigtht{
      overflow: hidden;
      img{
        width: 55px;
        vertical-align: middle;
      }
      span{
        font-size: 25px;
      }
    }
  }
</style>
