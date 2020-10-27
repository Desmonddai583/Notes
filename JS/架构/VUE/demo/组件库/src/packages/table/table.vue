<template>
  <div class="zh-table" ref="wrapper">
    <div class="table-wrapper" :style="{height}" ref="tableWrapper">
      <table ref="table">
        <thead>
          <tr>
            <th v-for="(col,index) in cloneColumns" :key="index" :style="{width:col.width+'px'}">
              <div v-if="col.type == 'selection'">
                <input type="checkbox" :checked="checkAllStatus" ref="checkAll" @change="selectAll" />
              </div>
              <span v-else class="zh-table-cell">
                <span>{{col.title}}</span>
                <span v-if="col.sortable" class="sortable">
                  <zh-icon
                    icon="up"
                    :class="{active:isAsc(col)}"
                    @click="sort(col,isAsc(col)?'normal':'asc')"
                  ></zh-icon>
                  <zh-icon
                    icon="down"
                    :class="{active:isDesc(col)}"
                    @click="sort(col,isDesc(col)?'normal':'desc')"
                  ></zh-icon>
                </span>
              </span>
            </th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(row,index) in cloneData" :key="index">
            <td v-for="(col,index) in cloneColumns" :key="index">
              <div v-if="col.type == 'selection'">
                <input type="checkbox" @change="selectOne($event,row)" :checked="isChecked(row)" />
              </div>
              <div v-else>
                <template v-if="col.slot">
                  <slot :name="col.slot" :row="row" :col="col"></slot>
                </template>
                <template v-else>{{row[col.key]}}</template>
              </div>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<script>
import cloneDeep from "lodash/cloneDeep";
export default {
  watch: {
    selectedItems() {
      // 我要设置半选状态
      if (this.cloneData.length != this.selectedItems.length) {
        if (this.selectedItems.length > 0) {
          return (this.$refs.checkAll[0].indeterminate = true);
        }
      }
      this.$refs.checkAll[0].indeterminate = false;
    }
  },
  computed: {
    checkAllStatus() {
      return this.cloneData.length == this.selectedItems.length;
    }
  },
  methods: {
    isAsc(col) {
      return col.sortType == "asc";
    },
    isDesc(col) {
      return col.sortType == "desc";
    },
    isChecked(row) {
      return this.selectedItems.some(r => r._id == row._id);
    },
    selectAll(e) {
      this.selectedItems = e.target.checked ? this.cloneData : [];
      this.$emit("on-select-all", this.selectedItems);
    },
    selectOne(e, row) {
      if (e.target.checked) {
        this.selectedItems.push(row);
      } else {
        this.selectedItems = this.selectedItems.filter(r => r._id != row._id);
      }
      this.$emit("on-select", this.selectedItems, row);
    },
    sort(col, type) {
      let data = cloneDeep(this.data);
      col.sortType = type;
      if (col.sortable !== "custom") {
        if (type !== "normal") {
          let key = col.key;
          this.cloneData = data.sort((a, b) => {
            if (type == "asc") {
              return a[key] - b[key];
            } else {
              return b[key] - a[key];
            }
          });
        } else {
          // 如果不需要排序 就把默认的结果 赋予给数据即可
          this.cloneData = data;
        }
      } else {
        this.$emit("on-sort-change", {
          col: cloneDeep(col),
          type
        });
      }
    }
  },
  // 单向数据流
  name: "zh-table",
  created() {
    this.cloneData = this.cloneData.map(row => {
      row._id = Math.random();
      return row;
    });
    this.cloneColumns = this.cloneColumns.map(col => {
      col.sortType = col.sortType ? col.sortType : "normal";
      this.sort(col, col.sortType);
      return col;
    });
  },
  data() {
    return {
      cloneColumns: cloneDeep(this.columns),
      cloneData: cloneDeep(this.data),
      selectedItems: []
    };
  },
  props: {
    columns: {
      type: Array,
      default: () => []
    },
    data: {
      type: Array,
      default: () => []
    },
    height: {
      type: String
    }
  },
  mounted() {
    if (this.height) {
      let wrapper = this.$refs.wrapper;
      let tableWrapper = this.$refs.tableWrapper;
      let table = this.$refs.table;

      let copyTable = table.cloneNode(); // 只拷贝表格
      let thead = table.children[0];
      tableWrapper.style.paddingTop =
        thead.getBoundingClientRect().height + "px";

      copyTable.appendChild(thead);
      copyTable.style.width = table.offsetWidth + "px";

      copyTable.classList.add("fix-header");

      let tds = table.querySelector("tbody tr").children;
      let ths = copyTable.querySelector("thead tr").children;

      tds.forEach((item, index) => {
        ths[index].style.width = item.getBoundingClientRect().width + "px";
      });

      wrapper.appendChild(copyTable);
    }
  }
};
</script>

<style lang="scss">
.fix-header {
  position: absolute;
  top: 0;
  left: 0;
}
.zh-table {
  position: relative;
  table {
    border-collapse: collapse;
    border-spacing: 0;
    width: 100%;
    th {
      background: #ccc;
    }
    th,
    td {
      border-bottom: 1px solid #ddd;
      padding: 8px;
      text-align: left;
    }
  }
  .zh-table-cell {
    display: inline-flex;
    justify-content: center;
    align-items: center;
    .sortable {
      display: flex;
      flex-direction: column;
      .zh-icon {
        width: 10px;
        height: 10px;
      }
      .active {
        fill: red;
      }
    }
  }
}

.table-wrapper {
  overflow-y: scroll;
}
</style>