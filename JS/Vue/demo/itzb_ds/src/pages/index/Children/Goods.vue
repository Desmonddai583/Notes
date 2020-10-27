<template>
    <div class="goods" v-if="list">
        <div class="goods-header clearfix">
          <div class="goods-title">
            <span>-</span>
            <span>{{list.name}}</span>
            <span>-</span>
          </div>
          <div class="goods-more f-right">
            <span>更多</span>
            <span class="iconfont">&#xe64e;</span>
          </div>
        </div>
        <div class="goods-footer">
          <ul v-if="list.goods_list">
            <li v-for="(value, index) in list.goods_list" :key="index" @click="switchTo(value.id)">
              <img :src="value.pic_url" alt="">
              <p class="goods-item-name">{{value.name}}</p>
              <p class="goods-item-price">{{value.price}}</p>
            </li>
          </ul>
        </div>
    </div>
</template>

<script>
    export default {
        name: "Goods",
        methods: {
          switchTo(id){
            this.$router.replace('/pages/goods/goods?id='+id);
          }

        },
        computed: {
          catlist(){
            return this.$store.state.homeInfo.cat_list;
          },
          list(){
            let catid = this.catid;
            let result = this.catlist.find(function (value, index) {
              return value.id === catid;
            });
            return result;
          }
        },
        props: ["catid"]
    }
</script>

<style scoped lang="less">
  .goods{
    padding: 0 15px;
    box-sizing: border-box;
    background: #fff;
    margin-top: 10px;
    .goods-header{
      height: 80px;
      line-height: 80px;
      position: relative;
      .goods-title{
        position: absolute;
        left: 50%;
        top: 50%;
        transform: translate(-50%, -50%);
        font-size: 30px;
      }
      .goods-more{
        span:nth-child(2){
          font-size: 35px;
          vertical-align: middle;
        }
      }
    }
    .goods-footer{
      ul{
        list-style: none;
        display: flex;
        justify-content: space-between;
        flex-wrap: wrap;
        li{
          width: 32%;
          text-align: center;
          margin: 10px 0;
          .goods-item-name{
            font-size: 25px;
            display: -webkit-box;
            -webkit-box-orient: vertical;
            -webkit-line-clamp: 2;
            overflow: hidden;
          }
          .goods-item-price{
            font-size: 30px;
            color: orangered;
            vertical-align: middle;
            &::before{
              font-family: "iconfont";
              font-style: normal;
              font-size: 40px;
              content: "\eb1e";
            }
          }
        }
      }
    }
  }
</style>
