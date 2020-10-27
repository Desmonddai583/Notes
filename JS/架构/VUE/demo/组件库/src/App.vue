<template>
  <div>
    <!-- pager-count  指代的是 当前分页器中最多有多少个按钮 -->
    <zh-table :columns="columns1" :data="data1" 
      @on-select="select"
      @on-select-all="selectAll"
      @on-sort-change="change"
      height="200px"
      >
      <template slot="name" slot-scope="{row,col}">
          <h1> {{row[col.key]}} </h1>
      </template>
      <template slot="action" slot-scope="{row,col}">
          <zh-button>删除</zh-button>
      </template>
      
      </zh-table>
    <zh-pagination :total="10" :pager-count="5" :current-page.sync="currentPage"></zh-pagination>
  </div>
</template>

<script>
export default {
  methods:{
    change({col,type}){
      console.log(col,type)
    },
    select(selection,row){
      // selection 表示选中的所有的  row 表示当前是哪一个
      console.log(selection,row)
    },
    selectAll(selection){
      console.log(selection)
    }
  },
  data() {
    return {
      currentPage: 6,
      columns1: [
        {
          type:'selection',
          width:60
        },
        {
          title: "Name",
          key: "name",
          slot:'name'
        },
        {
          title: "Age",
          key: "age",
          sortable:'custom', // iview  默认排序 排序方法 custom（远程排序）
          sortType:'asc',
        },
        {
          title: "Address",
          key: "address"
        },
        {
          title:'operator',
          slot:'action',
          key: "operator"
        }
      ],
      data1: [
        {
          name: "John Brown",
          age: 18,
          address: "New York No. 1 Lake Park",
          date: "2016-10-03"
        },
        {
          name: "Jim Green",
          age: 24,
          address: "London No. 1 Lake Park",
          date: "2016-10-01"
        },
        {
          name: "Joe Black",
          age: 30,
          address: "Sydney No. 1 Lake Park",
          date: "2016-10-02"
        },
        {
          name: "Jon Snow",
          age: 26,
          address: "Ottawa No. 2 Lake Park",
          date: "2016-10-04"
        }
      ]
    };
  }
};
</script>

<style lang="scss">
</style>