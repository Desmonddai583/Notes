<template>
  <div id="app">
    珠峰的年龄{{age}}
    <br />
    我的年龄 {{myAge}}
    {{$store.state.a.age}}
    {{$store.state.b.c.age}}
    {{$store.state.b.age}}
    <br />
    {{$store.state.b.d.age}}
    <br />
    <button @click="syncChange()">点我更改</button>
    <button @click="asyncChange()">异步更改</button>
    <!-- 
    <button @click="asyncChange()">异步更改</button>-->
  </div>
</template>

<script>
// vue的辅助方法
// import {mapMutations} from 'vuex'; // 映射状态
import {mapState,mapGetters,mapMutations,mapActions} from './vuex';


export default {
  name: "app",
  computed:{ // 只是写成了计算属性
    ...mapGetters(['myAge']), // {myAge:}
    ...mapState(['age']) // {age:fn}
    // age(){
    //   return this.$store.state.age
    // }
  },
  methods: {
    ...mapMutations({aaa:'syncChange'}),
    ...mapActions({bbb:'asyncChange'}),
    syncChange() {
      // 如果父亲没有命名空间 就不要增加父亲的命名空间
      this.aaa(10);
    },
    asyncChange() {
      this.bbb(5)
    }
  }
};
</script>

<style>
</style>
