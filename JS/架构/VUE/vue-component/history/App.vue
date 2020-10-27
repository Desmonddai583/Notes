<template>
  <div>
    <!-- <Parent @eat="eat"></Parent>
    <button @click="$broadcast('drink','grandson','xxx')">触发grandson中的drink方法</button>-->
    <Test a="1" b="2" c="3" d="4" @click="click" @mousedown="mousedown"></Test>
  </div>
</template>

<script>
// 组件的是有规则 1，定义组件  2.引入  3.注册组件  4.使用组件
// 注册时和使用时命名一致
import Parent from "./components/parent";
import Test from "./components/test";
export default {
  data() {
    return { msg: "hello" };
  },
  components: {
    Parent,
    Test
  },
  methods: {
    eat(value) {
      console.log("parent 中的 eat方法", value);
    },
    click() {
      console.log("click");
    },
    mousedown() {
      console.log("mousedown");
    }
  }
};
</script>

<style scoped>
</style>