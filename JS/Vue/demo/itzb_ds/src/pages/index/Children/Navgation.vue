<template>
  <div class="navgation clearfix">
    <ul>
      <li v-for="(item, index) in navlist" :key="index">
        <a :href="item.url">
          <img :src="item.pic_url" alt="">
          <p>{{item.name}}</p>
        </a>
      </li>
    </ul>
  </div>
</template>

<script>
    export default {
        name: "Navgation",
        computed: {
          navlist(){
            return this.$store.state.homeInfo.nav_icon_list;
          }
        }
    }
</script>

<style scoped lang="less">
  .navgation{
    width: 100%;
    background: #fff;
    ul{
      list-style: none;
      display: flex;
      flex-wrap: wrap;
      li{
        text-align: center;
        margin: 25px 53px;
        img{
          width: 80px;
        }
        p{
          margin-top: 10px;
          font-size: 25px;
          color: #666;
        }
      }
    }
  }
</style>
