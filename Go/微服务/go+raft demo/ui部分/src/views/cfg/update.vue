<template>
  <div class="app-container">
    <el-form ref="form" :model="config" label-width="120px">
      <el-form-item label="配置Key">
        <el-input style="width: 250px"  disabled  :value="'/'+config.group+'/'+config.dataId+'/'+config.version"/>
      </el-form-item>
      <el-form-item label="描述">
        <el-input style="width: 350px"  type="textarea" v-model="configValue.desc"   />
      </el-form-item>
      <el-form-item label="MD5">
        <el-input style="width: 350px"  disabled    v-model="configValue.md5" />
      </el-form-item>
      <el-form-item label="配置内容">
        <el-input   rows="5"  type="textarea"   v-model="configValue.content"  />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" @click="onSubmit">保存</el-button>
        <el-button @click=" $router.back()">返回</el-button>
      </el-form-item>
    </el-form>
  </div>
</template>

<script>
  import { getConfig ,saveConfig} from '@/api/cfg'
export default {
  data() {
    return {
      config:{
        group:'',
        dataId:'',
        version:''
      },
      configValue:{
        desc:'',
        md5:'',
        context:''
      }
    }
  },
  created(){
      this.config=this.$route.params.config;
      this.loadConfig()
      if(this.config==null){
        this.$router.push({name:'cfgList'})
      }
  },
  methods: {
    loadConfig(){
      getConfig(this.config).then(rsp=>{
         this.configValue=rsp.data
      })
    },
    onSubmit() {
      let obj=Object.assign({},this.config,this.configValue)
      let formData=new FormData();
      for(var prop in obj){
        formData.append(prop,obj[prop])
      }
      saveConfig(formData).then(rsp=>{
        if(rsp.data.message && rsp.data.message==="Ok"){
          this.$router.push({name:'cfgList'})
        }
      }).catch(err=>{
        this.$message({ type: 'error', message: '保存失败,数据不完整!'});
      })
    },
    onCancel() {

    }
  }
}
</script>

<style scoped>
.line{
  text-align: center;
}
</style>

