<template>
  <div class="app-container">
    <el-form ref="form" :model="config" label-width="120px">
      <el-form-item label="分组">
        <el-select   allow-create v-model="config.group" filterable placeholder="输入分组">
          <el-option
            v-for="item in groups"
            :key="item"
            :label="item"
            :value="item">
          </el-option>
        </el-select>
      </el-form-item>
      <el-form-item label="数据ID">
        <el-input style="width: 350px"    v-model="config.dataId"   />
      </el-form-item>
      <el-form-item label="版本">
        <el-select v-model="config.version" placeholder="请选择版本">
          <el-option v-for="v in 10" :label="'v'+v" :value="'v'+v" />
        </el-select>
      </el-form-item>
      <el-form-item label="描述">
        <el-input style="width: 350px"  type="textarea" v-model="configValue.desc"   />
      </el-form-item>
      <el-form-item label="配置内容">
        <el-input   rows="5"  type="textarea"   v-model="configValue.content"  />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" @click="onSubmit">保存</el-button>

      </el-form-item>
    </el-form>
  </div>
</template>

<script>
  import { getGroups,saveConfig } from '@/api/cfg'
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
        },
        groups:[]
      }
    },
    created(){
       getGroups().then(rsp=>{
          this.groups=rsp.data.result
       })
    },
    methods: {
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

