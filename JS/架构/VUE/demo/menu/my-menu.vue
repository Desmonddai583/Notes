<template>
  <el-menu>
      <!-- 默认循环第一层 -->
   
    <template v-for="d in data">
        <resub :data="d" :key="d.id"></resub>
    </template>
    <!-- <el-menu-item>根1</el-menu-item>
    <el-submenu>
      <template slot="title">根2</template>
      <el-menu-item>根2-1</el-menu-item>
      <el-menu-item>根2-2</el-menu-item>
    </el-submenu>
    <el-menu-item>根3</el-menu-item>
    <el-menu-item>根4</el-menu-item>-->
  </el-menu>
</template>

    
  
<script>
import elMenu from "./components/el-menu.vue";
import elMenuItem from "./components/el-menu-item.vue";
import elSubmenu from "./components/el-submenu.vue";
import resub from './resub';
export default {
  props: {
    data: {
      type: Array,
      default: () => []
    }
  },
  components: {
    resub,
    "el-menu": elMenu,
    "el-menu-item": elMenuItem,
    "el-submenu": elSubmenu
  }
};
</script>