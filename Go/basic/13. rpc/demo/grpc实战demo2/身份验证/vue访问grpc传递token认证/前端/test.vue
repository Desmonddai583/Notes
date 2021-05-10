<template>
  <div style="margin-top: 50px">
    <el-button @click="requestToken" type="danger" >请求token</el-button>
    <el-button @click="requestGrpc" type="primary">请求grpc</el-button>
  </div>

</template>
<script>
  import request from '@/utils/request'
  import { ProdServiceClient } from '@/grpc/service_grpc_web_pb'
  import { ProdRequest } from '@/grpc/models_pb'
  export default {
    data(){
      return{
        token:"guest", //默认是guest
      }
    },

    methods:{
      requestGrpc(){
        const client = new ProdServiceClient('http://localhost:8082');
        const req=new ProdRequest()
        req.setProdId(789)
        const metadata = {"Content-Type": "application/grpc-web-text","token":this.token };
        client.getProd(req,metadata,(err,rsp)=>{
          if (err) {
            alert("grpc失败"+err.message)
          } else {
            console.log(rsp.getResult().getName());
          }
        })
      },
      requestToken(){
        request.get("http://localhost:9090/access_token?userid=shenyi&secret=123")
          .then(rsp=>{
            this.token=rsp.token
            alert("token获取成功"+this.token)
          }).catch(e=>{
            alert("token获取失败"+e.response.data.message)
        })
      }
    }
  }
</script>
