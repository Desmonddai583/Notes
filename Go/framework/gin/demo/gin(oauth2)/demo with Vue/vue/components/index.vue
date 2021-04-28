<template>
    <div>
        <p>这里是首页</p>
        <router-link :to='{name:"deptslist"}'>点这里访问部门列表</router-link>
    </div>

</template>
<script>
    module.exports ={
        data(){
            return {

            }
        },
        async created(){

        },
        methods: {

        }
    }
</script>