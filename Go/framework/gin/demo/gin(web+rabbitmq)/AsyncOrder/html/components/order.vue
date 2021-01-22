<template>
    <div style="text-align: center;margin:100px auto">
        <div style="width:300px;height:200px;border:solid 1px darkgreen;margin: 0 auto;" v-show="loading" >
            正在下单中。。。。
        </div>
        <div><button @click="createOrder">点这里下单</button></div>

    </div>
</template>
<script>
   module.exports ={
       data(){
           return {
                loading: false
           }
       },
       methods:{
            async getResult(orderNo){
                try{
                    const rsp = await  axios.get( 'http://localhost:8080/result?orderno=' + orderNo)
                    const { result } = rsp.data
                    if(result > 0 ){
                        alert("下单成功")
                        this.loading = false
                    }else{
                        console.log("继续轮询")
                        setTimeout(()=>this.getResult(orderNo),3000)
                    }
                }catch (e) {
                    console.log(e)
                }
            },
            async createOrder(){
                try{
                    const rsp = await  axios.post( 'http://localhost:8080/')
                    const { orderno } = rsp.data
                    this.loading = true
                    console.log(orderno)
                    this.getResult(orderno)
                }catch (e) {
                    alert(e)
                }

            }
       }

   }
</script>