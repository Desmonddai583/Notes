<template>
    <div>
        <a href="http://localhost:3000/bar">点击</a>
        foo <button @click="show()">点击</button>
    </div>
</template>


<script>
export default {
    methods:{
        show(){
            alert(1);
        }
    }
}
</script>