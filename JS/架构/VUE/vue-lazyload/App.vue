<template>
    <div class="box">
        <li v-for="img in imgs" :key="img">
            <img v-lazy="img">
        </li>        
    </div>
</template>
<script>
import axios from 'axios'; // 基于promise async + await
export default {
    data(){
        return {imgs:[]}
    },
     created(){ // vue的生命周期是同步执行的
       axios.get('http://www.fullstackjavascript.cn:9999/api/img').then(({data})=>{
           this.imgs = data;
       })
     }
}
</script>
<style>
.box {
    height:300px;
    overflow: scroll;
    width: 200px;
}
img{
    width: 100px; height:100px;
}
</style>