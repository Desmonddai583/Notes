<template>
  <div class="app-container">
    <el-table
      v-loading="listLoading"
      :data="list"
      element-loading-text="Loading"
      border
      fit
      highlight-current-row
    >
      <el-table-column label="分组">
        <template slot-scope="scope">
          {{ scope.row.group }}
        </template>
      </el-table-column>
      <el-table-column label="数据ID"  align="center">
        <template slot-scope="scope">
          <span>{{ scope.row.dataId }}</span>
        </template>
      </el-table-column>
      <el-table-column label="版本"  align="center">
        <template slot-scope="scope">
          <span>{{ scope.row.version }}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作"  align="center">
        <template slot-scope="scope">
          <router-link :to="{name:'cfgUpdate',params:{config:scope.row}}">
            <el-button size="small" type="primary" icon="el-icon-edit" circle></el-button>
          </router-link>
          <el-button type="danger" @click="rmConfig(scope.row)" icon="el-icon-delete" circle size="small" ></el-button>
        </template>
      </el-table-column>

    </el-table>
  </div>
</template>

<script>
import { getConfigList,rmConfig } from '@/api/cfg'

export default {

  data() {
    return {
      list: null,
      listLoading: true
    }
  },
  created() {
    this.fetchData()
  },
  methods: {
    fetchData() {
      this.listLoading = true
      getConfigList().then(response => {
        this.list = response.data.result
        this.listLoading = false
      })
    },
    rmConfig(config){
      this.$confirm('此操作将永久删除该配置, 是否继续?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        rmConfig(config).then(rsp=>{
          if(rsp.data.message && rsp.data.message==="Ok"){
            this.$message({ type: 'success', message: '删除成功!' });
            this.fetchData()

          }else{
            this.$message({ type: 'error', message: '删除失败!'+rsp.data.message });
          }
        })

      }).catch(() => {

      });
    }
  }
}
</script>
