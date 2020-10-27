<template>
  <section class="zh-container" :class="{isVertical}">
    <slot></slot>
  </section>
</template>
<script>
export default {
  name: "zh-container",
  data() {
    return { isVertical: true };
  },
  mounted() {
    this.isVertical = this.$children.some(child =>
      ["zh-footer", "zh-header"].includes(child.$options.name)
    );
  }
};
</script>
<style lang="scss">
.zh-container {
  display: flex;
  flex-direction: row;
  flex:1
}
.zh-container.isVertical {
  flex-direction: column;
}
</style>