<template>
  <ul class="zh-pagination">
    <li>
      <zh-icon icon="left" @click="select(currentPage-1)"></zh-icon>
    </li>
    <li>
      <span :class="{active:currentPage === 1}" @click="select(1)">1</span>
    </li>
    <li v-if="showPrevMore">
      <span>...</span>
    </li>
    <li v-for="p in pagers" :key="p">
      <span  :class="{active:currentPage === p}" @click="select(p)">{{p}}</span>
    </li>
    <li v-if="showNextMore">
      <span>...</span>
    </li>
    <li>
      <span  :class="{active:currentPage === total}" @click="select(total)">{{total}}</span>
    </li>
    <li>
      <zh-icon icon="right" @click="select(currentPage+1)"></zh-icon>
    </li>
  </ul>
</template>

<script>
export default {
  name: "zh-pagination",
  data() {
    return { showPrevMore: false, showNextMore: false };
  },
  methods:{
      select(current){
          if(current < 1){
              current = 1;
          }
          if(current > this.total){
              current = this.total
          }
          if(current !== this.currentPage){
              this.$emit('update:current-page',current);
          }
      }
  },    
  computed: {
    
    // 最多显示7个按钮
    // 当前是第四页  1 2 3 4 5 6 。。。10
    // 当前显示的是第五页 1 ... 3 4 5 6 7 ... 10
    // 如果当前显示的是第七页 1 ... 5 6 7 8 9 10
    // 1 2 3 4 5 6 7 8 9 10
    pagers() {
      //  总共的页数
      let total = this.total;
      let pagerCount = this.pagerCount;
      let middleValue = Math.floor(this.pagerCount / 2);
      let currentPage = this.currentPage;
      //  计算是否显示前面的。。。 还是显示后面的。。。
      let showPrevMore = false;
      let showNextMore = false;
      if (total > pagerCount) {
        // 需要显示...
        if (currentPage > middleValue + 1) {
          showPrevMore = true;
        }
        if (currentPage < total - middleValue) {
          showNextMore = true;
        }
      }
      // 如果前面 有...  当前页为5的时候  1  ... 3  4  5  6 7  ...    10
      let arr = [];
      if (showPrevMore && !showNextMore) {
          //  拿到总个数  10  页面上一共出来5个 
          let  start = total - (pagerCount -2);
          for(let i = start; i< total ;i++){
              arr.push(i);
          }
      } else if (!showPrevMore && showNextMore) {
          for(let i = 2; i < pagerCount ; i++){
               arr.push(i);
          }
      } else if (showPrevMore && showNextMore) {
          let val = Math.floor((pagerCount -2)/2);
          for(let i = currentPage - val ; i<= currentPage + val;i++){
              arr.push(i);
          }
      } else {
        for (let i = 2; i < total; i++) {
          arr.push(i);
        }
      }

      this.showPrevMore = showPrevMore;
      this.showNextMore = showNextMore;

      return arr;
    }
  },
  props: {
    total: {
      type: Number,
      default: 1
    },
    pagerCount: {
      type: Number,
      default: 7
    },
    currentPage: {
      type: Number,
      default: 1
    }
  }
};
</script>

<style scoped lang="scss">
.zh-pagination li {
  list-style: none;
  display: inline-flex;
  vertical-align: middle;
    user-select: none;
  .active{
      color:red
  }
}
</style>