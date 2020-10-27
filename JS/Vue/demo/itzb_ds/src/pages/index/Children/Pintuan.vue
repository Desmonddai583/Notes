<template>
    <div class="pintuan clearfix">
        <div class="pintuan-header">
            <div class="pintuan-title f-left">
              <span class="iconfont">&#xe62e;</span>
              <span>限量拼团, 每日避逛</span>
            </div>
            <div class="pintuan-more f-right">
              <span>更多</span>
              <span class="iconfont">&#xe64e;</span>
            </div>
        </div>
        <div class="pintuan-footer">
          <ul v-if="pintuaninfo" ref="skcontent">
            <li v-for="(item, index) in pintuaninfo.goods_list" :key="index" ref="skitem">
              <img :src="item.pic" alt="">
              <p class="pintuan-name">{{item.name}}</p>
              <p class="pintuan-price">{{item.price}}</p>
              <p class="pintuan-sale">已拼{{item.sale_num}}</p>
            </li>
          </ul>
        </div>
    </div>
</template>

<script>
    // 导入自己封装的工具类
    import Tools from "@/assets/js/tools.js"

    export default {
        name: "pintuan",
        computed: {
            pintuaninfo(){
              return this.$store.state.homeInfo.pintuan;
            }
        },
        watch: {
          // 监听当前界面数据的变化, 只有拿到服务器返回的数据了, 才能计算倒计时
          "pintuaninfo": function () {
            this.$nextTick(function () {
              // 执行到$nextTick的回到函数,
              // 代表不仅数据被更新了, 界面也被更新了
              if(this.$refs.skitem.length > 0){
                let width = this.$refs.skitem.length * this.$refs.skitem[0].offsetWidth;
                this.$refs.skcontent.style.width = width + "px";
              }
            });

          }
        }
    }
</script>

<style scoped lang="less">
  .pintuan{
    width: 100%;
    margin-top: 10px;
    overflow: hidden;
    .pintuan-header{
      height: 80px;
      line-height: 80px;
      background: #fff;
      padding: 0 15px;
      box-sizing: border-box;
      font-size: 30px;
      color: #666;
      .pintuan-title{
        span:nth-child(1){
          font-size: 40px;
          color: orangered;
          margin-right: 15px;
          vertical-align: middle;
        }
        span:nth-child(2){
          color: orangered;
          margin-right: 10px;
        }
      }
      .pintuan-more{
          span:nth-child(2){
            font-size: 35px;
            vertical-align: middle;
          }
      }
      .pintuan-time{
        margin-left: 15px;
        span{
          display: inline-block;
          width: 35px;
          height: 35px;
          line-height: 35px;
          text-align: center;
          border-radius: 5px;
          font-size: 16px;
          color: #fff;
          background: linear-gradient(to bottom, #666, #000);
        }
      }
    }
    .pintuan-footer{
      width: 100%;
      margin-top: 2px;
      // 让容器中的内容可以水平滚动
      overflow-x: scroll;
      background: #fff7f5;
      // 隐藏系统默认的滚动条
      &::-webkit-scrollbar{
        display: none;
      }
      ul{
        list-style: none;
        display: flex;
        li{
          text-align: center;
          padding: 15px;
          background: #fff;
          img{
            width: 210px;
          }
          .pintuan-name{
            display: -webkit-box;
            -webkit-box-orient: vertical;
            -webkit-line-clamp: 2;
            overflow: hidden;
          }
          .pintuan-price{
            font-size: 30px;
            color: orangered;
            margin-top: 15px;
            &::before{
              font-family: "iconfont";
              font-style: normal;
              font-size: 40px;
              content: "\eb1e";
            }
          }
          .pintuan-sale{
            background: #fff;
            font-size: 25px;
            margin-top: 5px;
          }
        }
      }
    }
  }
</style>
