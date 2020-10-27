<template>
  <div class="home" v-if="modulelist">
    <component :is="item.name" v-for="(item, index) in modulelist" :key="index"></component>
    <!--
    <Header></Header>
    <Banner></Banner>
    <Notice></Notice>
    <Navgation></Navgation>
    <Seckiller></Seckiller>
    <Coupon></Coupon>
    <Pintuan></Pintuan>
    <Topic></Topic>
    <Goods></Goods>
    -->
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
        watch: {
          "modulelist": function () {
            this.modulelist.forEach(function (value, index) {
              if(value.name === 'nav'){
                value.name = "Navgation"
              }
            });
            console.log(this.modulelist);
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
    padding-bottom: 300px;
  }
</style>
