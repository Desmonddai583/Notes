<template>
  <div class="home" v-if="modulelist">
    <component :is="item.name" v-for="(item, index) in modulelist" :key="index" :catid="item.name === 'single_cat' ? item.cat_id : ''"></component>
  </div>
</template>

<script>
    import Search from './Children/Header'
    import Banner from './Children/Banner'
    import Notice from './Children/Notice'
    import Navgation from './Children/Navgation'
    import Miaosha from './Children/Seckiller'
    import Coupon from './Children/Coupon'
    import Pintuan from './Children/Pintuan'
    import Topic from './Children/Topic'
    import single_cat from './Children/Goods'

    export default {
        name: "index",
        created(){
          this.$store.dispatch("requestHome");
        },
        computed: {
          modulelist(){
            return this.$store.state.homeInfo.module_list;
          }
        },
        components: {
          Search,
          Banner,
          Notice,
          Navgation,
          Miaosha,
          Coupon,
          Pintuan,
          Topic,
          single_cat
        }
    }
</script>

<style scoped lang="less">
  .home{
    padding-bottom: 115px;
    box-sizing: border-box;
  }
</style>
