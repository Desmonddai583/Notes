<template>
    <div class="header">
      <slot name="left">
        <a href="#" class="left-menu iconfont"@click="back()">&#xe622;</a>
      </slot>
      <slot name="center" class="header-center">
        <form class="search">
          <input type="text" placeholder="华为手机最牛X的手机" @keyup="change()" v-model="msg">
        </form>
      </slot>
      <slot name="right">
        <a href="#" class="right-menu iconfont" @click="more()">&#xe61c;</a>
      </slot>
    </div>
</template>

<script>
    export default {
        name: "Header",
        props: ['title'],
        data(){
            return{
              msg: ""
            }
        },
        methods: {
          back(){
            this.$emit("parentBack");
          },
          more(){
            this.$emit("parentMore");
          },
          change(){
            this.$emit("parentChange", this.msg);
          }
        },
        mounted(){
          this.$nextTick(function () {
            // 在组件中通过this.$el可以获取到当前组件的根元素
            // console.log(this.$el);
            // 在组件中通过this.$parent可以获取到当前组件的父组件
            // console.log(this.$parent);
            // console.log(this.$parent.$el);

            // 1.获取头部的高度
            let headerHeight = this.$el.offsetHeight;
            // 2.获取头部组件的父组件
            let parentEle = this.$parent.$el;
            // 3.设置父组件的padding
            parentEle.style.paddingTop = headerHeight + "px";
          })
        }
    }
</script>

<style scoped lang="less">
  .header{
    width: 100%;
    height: 80px;
    line-height: 80px;
    padding: 0 15px;
    box-sizing: border-box;
    position: fixed;
    top: 0;
    left: 50%;
    transform: translateX(-50%);
    z-index: 999;
    background: #fff;
    border-bottom: 1px solid #ccc;
    display: flex;
    justify-content: space-between;
    align-items: center;
    .header-center{
      flex: 1;
    }
    .left-menu{
      font-size: 30px;
    }
    .right-menu{
      font-size: 50px;
    }
    .search{
      width: 100%;
      padding: 0 15px;
      position: relative;
      input{
        width: 100%;
        height: 46px;
        border-radius: 23px;
        font-size: 14px;
        text-indent: 50px;
        background: #f7f7f7;
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
