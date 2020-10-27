<template>
    <div class="seckiller clearfix">
        <div class="seckiller-header">
            <div class="seckiller-title f-left">
              <span class="iconfont">&#xe62d;</span>
              <span>整点秒杀</span>
              <span v-if="seckillerinfo">{{seckillerinfo.name}}</span>
            </div>
            <div class="seckiller-time f-left">
              <span ref="hour">00</span>
              :
              <span ref="min">00</span>
              :
              <span ref="sec">00</span>
            </div>
            <div class="seckiller-more f-right">
              <span>更多</span>
              <span class="iconfont">&#xe64e;</span>
            </div>
        </div>
        <div class="seckiller-footer">
          <ul v-if="seckillerinfo" ref="skcontent">
            <li v-for="(item, index) in seckillerinfo.goods_list" :key="index" ref="skitem">
              <img :src="item.pic" alt="">
              <p class="miaosha-price">{{item.miaosha_price}}</p>
              <p class="origin-price">{{item.price}}</p>
            </li>
          </ul>
        </div>
    </div>
</template>

<script>
    // 导入自己封装的工具类
    import Tools from "@/assets/js/tools.js"

    export default {
        name: "Seckiller",
        methods: {
          startAnimation(){
            // 1.获取需要操作的元素
            let hourEle = this.$refs.hour;
            let minEle = this.$refs.min;
            let secEle = this.$refs.sec;
            // 2.获取倒计时的总时长
            let restTime = this.seckillerinfo.rest_time;
            // 3.开启定时器不断计算和设置事件
            setInterval(function () {
              let time = Tools.fmtTime(restTime);
              hourEle.innerText = time.hour;
              minEle.innerText = time.min;
              secEle.innerText = time.sec;
              restTime -= 1;
            }, 1000);
          }
        },
        computed: {
            seckillerinfo(){
              return this.$store.state.homeInfo.miaosha;
            }
        },
        watch: {
          // 监听当前界面数据的变化, 只有拿到服务器返回的数据了, 才能计算倒计时
          "seckillerinfo": function () {
            // 一般情况下通过watch监听服务器返回的数据之后要操作界面
            // 都会和.$nextTick配合使用, 他们两是一对黄金搭档
            console.log("watch");
            // 执行到这, 仅仅代表数据被更新了
            this.$nextTick(function () {
              // 1.开启倒计时
              this.startAnimation();

              // 2.动态计算商品的总宽度
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
  .seckiller{
    width: 100%;
    margin-top: 10px;
    overflow: hidden;
    .seckiller-header{
      height: 80px;
      line-height: 80px;
      background: #fff;
      padding: 0 15px;
      box-sizing: border-box;
      font-size: 30px;
      color: #666;
      .seckiller-title{
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
      .seckiller-more{
          span:nth-child(2){
            font-size: 35px;
            vertical-align: middle;
          }
      }
      .seckiller-time{
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
    .seckiller-footer{
      width: 100%;
      background: #fff;
      margin-top: 2px;
      // 让容器中的内容可以水平滚动
      overflow-x: scroll;
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
          img{
            width: 210px;
          }
          .miaosha-price{
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
          .origin-price{
            font-size: 12px;
            color: #666;
            &::before{
              font-family: "iconfont";
              font-style: normal;
              font-size: 30px;
              content: "\eb1e";
            }
          }
        }
      }
    }
  }
</style>
