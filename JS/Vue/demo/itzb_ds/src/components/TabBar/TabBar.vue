<template>
    <div class="tabbar">
      <ul>
        <li @click="switchTo(item.url)" v-for="(item, index) in navbarInfo.navs" :key="index">
          <!--
          route.path获取当前浏览器中的路由地址
          item.url获取当前按钮的路由地址
          通过includes判断当前按钮的路由地址和浏览器当前的地址是否相同
          , 如果相同代表寻踪
          -->
          <img :src="$route.path.includes(item.url) ? item.active_icon : item.icon" alt="">
          <p :style="{color: $route.path.includes(item.url) ? item.active_color : item.color}">{{item.text}}</p>
        </li>
      </ul>
    </div>
</template>

<script>
  // 1.通过Vuex提供的mapState辅助函数导入vuex中的数据
  import { mapState } from 'vuex'

    export default {
        name: "TabBar",
        methods: {
          switchTo(path){
            // 通过代码修改路由地址
            this.$router.replace(path);
          }
        },
        created(){
            // 1.告诉Vuex需要调用Actions中的requestNavbar方法
            this.$store.dispatch("requestNavbar");
        },
        computed: mapState(['navbarInfo'])
        // computed: {
        //   count(){
        //     return this.$store.state.count;
        //   },
        // }
      //  这句话最终的效果和上面的代码一样
      //  computed: mapState(['count', 'value', 'num'])
      //   computed: {
      //       name(){ // 非共享数据
      //         return "www.it666.com";
      //       },
      //       ...mapState(['count', 'value', 'num'])
      //   }
    }
</script>

<style scoped lang="less">
  .tabbar{
    width: 100%;
    height: 115px;
    background: #fff;
    position: fixed;
    left: 50%;
    transform: translateX(-50%);
    bottom: 0;
    z-index: 999;
    border-top: 1px solid #ccc;
    ul{
      list-style: none;
      display: flex;
      li{
        flex: 1;
        text-align: center;
        img{
          width: 50px;
          height: 50px;
          margin-top: 25px;
        }
        p{
          font-size: 23px;
        }
      }
    }
  }
</style>
