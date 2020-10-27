<template>
  <el-submenu :key="data.id" v-if="data.children">
    <template slot="title">{{data.title}}</template>
    <template v-for="d in data.children">
        <resub :key="d.id" :data="d"></resub>
    </template>
  </el-submenu>
  <el-menu-item :key="data.id" v-else>{{data.title}}</el-menu-item>
</template>

<script>
import elMenu from "./components/el-menu.vue";
import elMenuItem from "./components/el-menu-item.vue";
import elSubmenu from "./components/el-submenu.vue";
export default {
  name:'resub', // 可以根据自己当前的组件名 循环自己
  props: {
    data: {}
  },
  components: {
    "el-menu": elMenu,
    "el-menu-item": elMenuItem,
    "el-submenu": elSubmenu
  }
};
</script>


周五 把vue用法结束掉 周六面试题
周日 vuex vue-router 原理

下周 周三vue源码 组件渲染流程 周五parser
周日 单元测试 vue-ssr

在下一周 ts + vue + 