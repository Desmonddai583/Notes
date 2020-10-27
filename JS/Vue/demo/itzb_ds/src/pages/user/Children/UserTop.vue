<template>
    <div class="user-top" v-if="userinfo">
      <img :src="userbg">
      <div class="user-info">
        <img :src="userinfo.avatar_url" alt="">
        <p class="user-level">{{userinfo.level_name}}</p>
        <p class="user-name">{{userinfo.nickname}}</p>
      </div>
      <div class="user-wallets">
        <ul v-if="wallets">
          <li v-for="(value, key, index) in wallets" :key="index">
            <img :src="value.icon" alt="">
            <p>{{value.text}}</p>
          </li>
        </ul>
      </div>
    </div>
</template>

<script>
    export default {
        name: "UserTop",
        computed: {
          userbg(){
            return this.$store.state.userinfo.user_center_bg;
          },
          userinfo(){
            return this.$store.state.userinfo.user_info;
          },
          wallets(){
            return this.$store.state.userinfo.wallets;
          }
        }
    }
</script>

<style scoped lang="less">
  .user-top{
    width: 100%;
    position: relative;
    &>img{
      height: 350px;
    }
    .user-info{
      position: absolute;
      top: 70px;
      left: 50%;
      transform: translateX(-50%);
      img{
        width: 135px;
        border-radius: 50%;
      }
      .user-level{
        width: 150px;
        height: 40px;
        line-height: 40px;
        text-align: center;
        background: rgba(0,0,0,0.5);
        border-radius: 20px;
        font-size: 20px;
        color: #fff;
      }
      .user-name{
        font-size: 30px;
        font-weight: bold;
        color: #fff;
        text-align: center;
        margin-top: 15px;
      }
    }
    .user-wallets{
      width: 100%;
      height: 140px;
      background: #fff;
      ul{
        height: 100%;
        display: flex;
        align-items: center;
        li{
          flex: 1;
          text-align: center;
          border-right: 1px solid #ccc;
          box-sizing: border-box;
          &:last-child{
            border: none;
          }
          img{
            width: 50px;
          }
          p{
            font-size: 30px;
            margin-top: 20px;
          }
        }
      }
    }
  }
</style>
