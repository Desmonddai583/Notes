<template>
        <div>
           <p>这里是部门列表,请查看控制台</p>

        </div>
</template>
<script>
    module.exports={
       created(){
                axios.get("http://api.me.com/depts").then(function (rsp) {
                        console.log(rsp.data)
                })
        }
    }
</script>