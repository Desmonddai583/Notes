<template>
  <div>
      {{$attrs}}

        <!-- 将所有属性都传递给儿子组件 -->
        <!-- {....xxx} -->
       <!-- <T v-bind="{a:1,v:2,c:3,d:3}"></T> -->
     
       <T v-on="$listeners" v-bind="$attrs"></T>
  </div>
</template>

<script>
// 这个组件只是过渡的 他不需要使用这些属性
// 如果在props里用了 attr里就会减少
// $attrs是响应式的 父亲变了 数据也会更新
import T from './t'
export default {
  inheritAttrs : false, // 这些属性 虽然没用 但是我不希望增加到dom元素上
  props: ["a", "b"],
  components:{
      T
  },
  methods:{
     
  }
};
</script>