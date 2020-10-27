<template>
  <mt-header :title="title" :fixed="true" ref="header">
    <mt-button icon="back" slot="left"></mt-button>
    <mt-button icon="more" slot="right"></mt-button>
  </mt-header>
</template>

<script>
    export default {
        name: "Header",
        props: ['title'],
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

<style>
  .mint-header{
    height: 80px;
    padding: 0 15px;
    box-sizing: border-box;
    background: #fff;
    border-bottom: 1px solid #ccc;
    color: #666;
  }
  .mint-header-title{
    font-size: 30px;
  }
  .mintui{
    font-size: 40px !important;
  }
</style>
