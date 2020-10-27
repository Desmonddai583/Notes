<template>
    <div class="header clearfix" ref="header">
      <a href="#" class="cat iconfont">&#xe606;</a>
      <form class="search">
        <input type="text" placeholder="华为手机, 世界上最牛X的手机">
      </form>
      <a href="#" class="login">登录</a>
    </div>
</template>

<script>
    export default {
        name: "Header",
        mounted(){
          // 1.获取头部的高度
          let headerEle = this.$refs.header;
          let headerHeight = headerEle.offsetHeight;
          // 2.监听网页的滚动
          window.onscroll = function () {
            let scrollTop = window.pageYOffset || document.documentElement.scrollTop || document.body.scrollTop;
            let opt = scrollTop/headerHeight;
            headerEle.style.background = "rgba(228,49,48,"+opt+")";
          };
        }
    }
</script>

<style scoped lang="less">
  .header{
    width: 100%;
    height: 80px;
    line-height: 80px;
    background: transparent;
    display: flex;
    padding: 0 15px;
    box-sizing: border-box;
    position: fixed;
    left: 50%;
    transform: translateX(-50%);
    top: 0;
    z-index: 999;
    .cat{
      font-size: 30px;
    }
    .login{
      font-size: 18px;
    }
    .search{
      flex: 1;
      padding: 0 15px;
      position: relative;
      input{
        width: 100%;
        height: 46px;
        border-radius: 23px;
        font-size: 14px;
        text-indent: 50px;
      }
      &::before{
        font-family: "iconfont";
        font-style: normal;
        font-size: 25px;
        content: "\e65b";
        position: absolute;
        left: 25px;
        top: 0;
      }
    }
  }
</style>
