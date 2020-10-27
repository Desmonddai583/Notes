<template>
  <div class="cat" ref="catView">
    <Header class="header"
            @parentBack="myback"
            @parentMore="mymore"
            @parentChange="mykeyup"></Header>
    <div class="cat-menu">
      <div class="menu-left">
        <ul v-if="catinfo">
          <li v-for="(item, index) in catinfo.list" :key="index" :class="{active: index === currentIndex}" @click="change(index)">
              <p>{{item.name}}</p>
          </li>
        </ul>
      </div>
      <div class="menu-right">
        <ul v-if="catinfo.list">
          <li v-for="(item, index) in catinfo.list[currentIndex].list" :key="index">
            <img :src="item.pic_url" alt="">
            <p>{{item.name}}</p>
          </li>
        </ul>
      </div>
    </div>
  </div>
</template>

<script>
    import BScroll from 'better-scroll'
    import Header from '@/components/Header/Header'

    import { mapState } from 'vuex'
    export default {
        name: "cat",
        data(){
          return {
            currentIndex: 0
          }
        },
        methods: {
          change(index){
            this.currentIndex = index;
          },
          myback(){
            console.log("myback");
          },
          mymore(){
            console.log("mymore");
          },
          mykeyup(msg){
            console.log("mykeyup", msg);
          }
        },
        components: {
          Header
        },
        created(){
            this.$store.dispatch("requestCat");
        },
        computed: mapState(["catinfo"]),
        watch: {
          "catinfo": function () {
            this.$nextTick(function () {
              new BScroll(".menu-left");
              new BScroll(".menu-right");
            })
          }
        },

    }
</script>

<style scoped lang="less">
  .cat{
    width: 100%;
    height: 100%;
    overflow: hidden;
    padding-bottom: 115px;
    box-sizing: border-box;
    .cat-menu{
      width: 100%;
      height: 100%;
      display: flex;
      .menu-left{
        width: 200px;
        background: #ccc;
        li{
          width: 100%;
          height: 105px;
          line-height: 105px;
          text-align: center;
        }
        .active{
          border-left: 2px solid orangered;
          box-sizing: border-box;
          background: #fff;
        }
      }
      .menu-right{
        flex: 1;
        overflow: hidden;
        background: #fff;
        height: 100%;
        ul{
          list-style: none;
          display: flex;
          justify-content: space-between;
          align-items: center;
          flex-wrap: wrap;
          li{
            width: 30%;
            text-align: center;
          }
        }
      }
    }
  }
</style>
