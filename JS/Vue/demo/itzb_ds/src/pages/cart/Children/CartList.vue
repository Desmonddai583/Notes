<template>
  <div class="cart-list">
    <div class="list-title">
      <a href="javascript:;" class="iconfont" @click="checkall">{{checkAllState ? '&#xe604;' : '&#xe651;'}}</a>
      <p>平台自营</p>
    </div>
    <div class="list-main">
      <ul v-if="all">
        <li v-for="(item, index) in all" :key="index">
          <div class="list-left">
            <a href="javascript:;" class="iconfont" @click="check(index)">{{checkItemsState[index] ? '&#xe604;' : '&#xe651;'}}</a>
            <img :src="item.goods_pic" alt="">
          </div>
          <div class="list-right">
            <div class="list-right-top">
              <p class="item-name">{{item.goods_name}}</p>
              <p class="item-attr">{{item.attr_list | attrfilter}}</p>
            </div>
            <div class="list-right-bottom">
              <p class="item-price">{{item.price}}</p>
              <div class="item-step">
                <button class="step-sub" @click="stepsub(index)">-</button>
                <input type="text" :value="item.num">
                <button class="step-add" @click="stepadd(index)">+</button>
              </div>
            </div>
          </div>
        </li>
      </ul>
    </div>
  </div>
</template>

<script>
    import {mapState, mapGetters} from "vuex"
    export default {
        name: "CartList",
        methods: {
          check(index){
            this.$store.dispatch("products/changeCheckItemState", index);
          },
          checkall(){
            this.$store.dispatch("products/changeCheckAllState");
          },
          stepsub(index){
            this.$store.dispatch("products/changeProductNum", {
              index: index,
              type: "sub"
            });
          },
          stepadd(index){
            this.$store.dispatch("products/changeProductNum", {
              index: index,
              type: "add"
            });
          },
        },
        filters: {
          attrfilter(value){
            let str = "";
            value.forEach(function (item, index) {
              str += item.attr_group_name + ":";
              str += item.attr_name + " ";
            });
            return str;
          }
        },
        computed: {
          // 如果是存储在一个单独模块中的, 那么映射的时候, 第一个参数需要传递模块的名称
          ...mapState('products', ['all', 'checkAllState', 'checkItemsState']),
          // all(){
          //   return this.$store.state.products.all;
          // },
          // ...mapGetters('products', ['checkItemsState'])
        },
        data(){
          return {
            flag: false
          }
        },
    }
</script>

<style scoped lang="less">
  .cart-list{
    padding: 0 25px;
    box-sizing: border-box;
    font-size: 30px;
    a{
      font-size: 30px;
      margin-right: 25px;
    }
    .list-title{
      height: 90px;
      line-height: 90px;
      display: flex;
      align-items: center;
      border-bottom: 1px solid #ccc;
    }
    .list-main{
      ul{
        width: 100%;
        li{
          height: 210px;
          display: flex;
          align-items: center;
          border-bottom: 1px solid #ccc;
          padding: 30px 0;
          box-sizing: border-box;
          .list-left{
            height: 100%;
            margin-right: 15px;
            img{
              width: 150px;
              vertical-align: middle;
            }
          }
          .list-right{
            height: 100%;
            flex: 1;
            .list-right-top{
              .item-name, .item-attr{
                display: -webkit-box;
                -webkit-box-orient: vertical;
                -webkit-line-clamp: 1;
                overflow: hidden;
                font-size: 30px;
              }
              .item-attr{
                font-size: 25px;
                margin: 15px 0;
              }
            }
            .list-right-bottom{
              display: flex;
              justify-content: space-between;
              align-items: center;
              .item-price{
                font-size: 30px;
                color: orangered;
                &::before{
                  font-family: "iconfont";
                  font-style: normal;
                  font-size: 40px;
                  content: "\eb1e";
                }
              }
              .item-step{
                .step-sub, .step-add{
                  border: none;
                  outline: none;
                  width: 60px;
                  height: 60px;
                  line-height: 60px;
                  text-align: center;
                  font-size: 30px;
                  background: #f7f7f7;
                }
                input{
                  width: 90px;
                  height: 60px;
                  line-height: 60px;
                  text-align: center;
                  font-size: 30px;
                  background: #f7f7f7;
                }
              }
            }
          }
        }
      }
    }
  }
</style>
