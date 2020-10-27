<template>
    <div class="header">
      <slot name="left">左边预留</slot>
      <slot name="center" class="header-center">中间预留</slot>
      <slot name="right">右边预留</slot>
    </div>
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
  }
</style>
