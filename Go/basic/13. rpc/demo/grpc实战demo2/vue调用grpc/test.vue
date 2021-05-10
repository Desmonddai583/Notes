<template>


</template>
<script>
  import { ProdServiceClient } from '@/grpc/service_grpc_web_pb'
  import { ProdRequest } from '@/grpc/models_pb'
  export default {
   created() {
     const client = new ProdServiceClient('http://localhost:8082');
     const req=new ProdRequest()
     req.setProdId(789)
     const metadata = {"Content-Type": "application/grpc-web-text"};
     client.getProd(req,metadata,(err,rsp)=>{
       if (err) {
         console.log(err.message);
       } else {
         console.log(rsp.getResult().getName());
       }
     })
     const stream=client.getProd_Stream(req,metadata)
     stream.on('data', function(response) {
       console.log(response.getResult().getId());
     });

     stream.on('end', function(end) {
       console.log("接收完毕")
     });



   }

  }
</script>
