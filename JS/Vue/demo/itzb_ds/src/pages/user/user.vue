<template>
  <div class="user">
    <Header>
      <p slot="center">个人中心</p>
    </Header>
    <UserTop></UserTop>
  </div>
</template>

<script>
    import Header from '@/components/Header/Header'
    import UserTop from './Children/UserTop'
    export default {
        name: "user",
        components: {
          Header,
          UserTop
        },
        created(){
            this.$store.dispatch("requestUser");
        }
    }
</script>

<style scoped lang="less">

</style>
