<template>
  <div id="app">
    <!--需要根据路由切换的内容-->
    <router-view></router-view>
    <!--底部工具条, 用于控制内容切换-->
    <TabBar ref="tabbar"></TabBar>
  </div>
</template>

<script>
  import TabBar from './components/TabBar/TabBar'

export default {
  name: 'App',
  components: {
    TabBar
  }
}
</script>

<style scoped lang="less">
  #app{
    width: 100%;
    height: 100%;
    background: #ccc;
  }
</style>
