<template>
  <div>
    <myDialog ref="dialog">
        <!-- 老版本的写法slot="" -->
        <!-- 插槽的数据默认使用的是当前组件的父级数据 -->
        <!-- 作用域插槽  希望用当前组件的数据 只能采用作用域插槽将数据传递出来-->
      <template #header>{{msg}}</template>
      <!-- <template v-slot:footer="{a,b,isShow}">footer {{a}} {{b}} {{isShow}}</template> -->

      <template slot="footer" slot-scope="{a}">{{a}}</template>
<!-- 
      <div slot="header">header</div>
      <div slot="footer">header</div>
-->
    </myDialog>
    <button @click="change">点我</button>
  </div>
</template>

<script>
import myDialog from "./components/my-dialog";
export default {
    data(){
        return {msg:'hello'}
    },
  components: {
    myDialog
  },
  mounted() {
    this.$bus.$emit("监听事件", "hello");
    this.$bus.$on("父", function() {
      console.log("被触发");
    });
  },
  methods: {
    change() {
      // 可以获取当前dialog组件中任何属性
      // 不要通过这种方式去改变组件的属性
      // ref 的用法 在普通元素 可以获取dom元素
      // v-for里面了 获取的是一组dom / 组件实例
      // 组件上了 当前组件的实例
      this.$refs.dialog.change();
    }
  }
};
</script>