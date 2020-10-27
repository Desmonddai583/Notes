<template>
  <div class="zh-date-picker" v-click-outside="handleBlur">
    <zh-input suffix-icon="rili" @focus="handleFocus" :value="formateDate" @change="handleChange"></zh-input>
    <div class="zh-date-content" v-if="isVisible">
      <div class="zh-date-picker-content">
        <template v-if="mode === 'dates'">
          <div class="zh-date-picker-header">
            <zh-icon icon="prev" @click="changeYear(-1)"></zh-icon>
            <zh-icon icon="left" @click="changeMonth(-1)"></zh-icon>
            <span>
              <b @click="mode='years'">{{tempTime.year}}</b>年
              <b @click="mode='months'">{{tempTime.month + 1}}</b>月
            </span>
            <zh-icon icon="right" @click="changeMonth(1)"></zh-icon>
            <zh-icon icon="next" @click="changeYear(1)"></zh-icon>
          </div>
          <div>
            <span v-for="week in weeks" class="cell" :key="week">{{week}}</span>
          </div>
          <div v-for="i in 6" :key="`row_${i}`">
            <span
              v-for="j in 7"
              :key="`col_${j}`"
              class="cell cell-dates"
              @click="selectDate(getCurrentDate(i,j))"
              :class="{
                    isNotCurrentMonth:!isCurrentMonth(getCurrentDate(i,j)),
                    isToday:isToday(getCurrentDate(i,j)),
                    isSelect:isSelect(getCurrentDate(i,j))
                }"
            >
              <!-- 99 乘法表   i 和 j是从第一个开始的  第二行的第一个 -->
              {{getCurrentDate(i,j).getDate()}}
            </span>
          </div>
        </template>
        <template v-if="mode === 'years'">
            <div class="zh-date-picker-header">
            <zh-icon icon="prev" @click="changeYear(-10)"></zh-icon>
            <span>
              <b @click="mode='years'">{{startYear}}年{{startYear+9}}年</b>
            </span>
            <zh-icon icon="next" @click="changeYear(10)"></zh-icon>
          </div>
        </template>
        <template v-if="mode === 'months'">
            <div class="zh-date-picker-header">
            <zh-icon icon="left" @click="changeYear(-1)"></zh-icon>
            <span>
              <b @click="mode='years'">{{this.tempTime.year}}年</b>
            </span>
            <zh-icon icon="right" @click="changeYear(1)"></zh-icon>
          </div>
        </template>
      </div>
    </div>
  </div>
</template>

<script>
// 这个可以判断点击的是否是自己内部元素
function getYearMonthDay(date) {
  let year = date.getFullYear();
  let month = date.getMonth();
  let day = date.getDate(); // 获取日期的 getDay
  return [year, month, day];
}
import clickOutside from "v-click-outside";
export default {
  name: "zh-date-picker",
  directives: {
    clickOutside: clickOutside.directive
  },
  props: {
    value: {
      // 显示的日期
      type: [String, Date],
      default: () => new Date()
    }
  },
  watch: {
    value(newValue) {
      // 监控value值变化 重新渲染页面
      // 根据最新的value 来更新 this.time / this.tempTime
      let [year, month, day] = getYearMonthDay(newValue);
      this.time = {
        year,
        month,
        day
      };
      this.tempTime = { ...this.time }; // 拷贝一个time属性用于后续选择的更改
    }
  },
  computed: {
    visibleData() {
      // 只要数据变化 会更新 tempTime，此时会重新计算42天
      // <!-- 先算 当前月有多少天 找到下一个月的1号的前一天  总天数 -->
      // <!-- 再去获取当前1号 是星期几 在前面 再加上那几天 -->
      // <!-- 42 - 刚才加的 + 月的总天数 = 剩下的 -->
      // <!-- 直接将自己向前移动多少天后 开始循环42天 -->
      let firstDay = new Date(this.tempTime.year, this.tempTime.month, 1); // 3月1日
      let weekDay = firstDay.getDay(); // 周日0 周六 6  // 周日
      weekDay = weekDay === 0 ? 7 : weekDay;
      // 毫秒戳 运算
      let start = firstDay - weekDay * 60 * 60 * 24 * 1000; // 让当前可是区域的开始调整到当前的开始部分
      let arr = []; // 循环42个
      for (let i = 0; i < 42; i++) {
        // 转回成事件
        arr.push(new Date(start + i * 60 * 60 * 24 * 1000));
      }
      return arr;
    },
    formateDate() {
      // 根据当前的time对象 算出来一个 日期格式
      if (this.value) {
        // 控制输入框中的内容
        let { year, month, day } = this.time;
        // 补0操作
        return `${year}-${(month + 1 + "").padStart(2, 0)}-${(
          day + ""
        ).padStart(2, 0)}`;
      }
    },
    startYear(){ // 2023  2020   2023 -  2023%10 = 3
        return this.tempTime.year - this.tempTime.year%10
    }
  },
  data() {
    // 只执行一次
    // 我需要通过用户传入的value 算出一个 年月日来   2012-10-04
    let [year, month, day] = getYearMonthDay(this.value || new Date()); // 根据当前的时间算出一个年月日
    return {
      isVisible: false,
      weeks: ["日", "一", "二", "三", "四", "五", "六"],
      months: [
        "一月",
        "二月",
        "三月",
        "四月",
        "五月",
        "六月",
        "七月",
        "八月",
        "九月",
        "十月",
        "十一月",
        "十二月"
      ],
      mode: "dates", // years || months
      time: {
        // 稍后我们现实的时间是通过 time来显示的
        year,
        month,
        day
      },
      tempTime: {
        // 我们操作的是这个时间
        year,
        month,
        day
      }
    };
  },
  methods: {
    handleChange(e) {
      // 失去焦点时更新用户输入
      let newValue = e.target.value;
      let regExp = /^(\d{4})-(\d{1,2})-(\d{1,2})$/;
      if (newValue.match(regExp)) {
        //  更新输入框内容
        // 自己兼容
        this.$emit("input", new Date(RegExp.$1, RegExp.$2 - 1, RegExp.$3));
      } else {
        e.target.value = this.formateDate; // 将原来的值赋予回去 不用了
      }
      this.handleBlur(); // 失去焦点
    },
    handleFocus() {
      // 当点击的是输入框的时候 就让当前的浮层显示出来
      this.isVisible = true;
    },
    handleBlur() {
      //  当点击整个div外侧时 需要隐藏弹层
      this.isVisible = false;
      this.mode = 'dates'
    },
    getCurrentDate(i, j) {
      return this.visibleData[(i - 1) * 7 + (j - 1)];
    },
    isCurrentMonth(date) {
      let { year, month } = this.tempTime; // 取出来当前用户选的是哪年 哪月
      let [y, m] = getYearMonthDay(date);
      return year === y && m === month; // 判断当前年月是否相等
    },
    isToday(date) {
      let [y, m, d] = getYearMonthDay(date);
      let [year, month, day] = getYearMonthDay(new Date());
      return year === y && month === m && day === d;
    },
    selectDate(date) {
      // 选择日期
      this.$emit("input", date); // 更改日期
      this.handleBlur(); // 隐藏面板
    },
    isSelect(date) {
      // 判断当前是否选中
      let { year, month, day } = this.time; // 当前选中的年月日
      let [y, m, d] = getYearMonthDay(date);
      return year == y && month === m && day === d;
    },
    // 更改年月 让系统自己算 不要自己考虑边界清框
    changeMonth(count) {
      // 更改月不要直接 + -
      const oldDate = new Date(this.tempTime.year, this.tempTime.month);
      const newDate = oldDate.setMonth(oldDate.getMonth() + count);
      let [year, month] = getYearMonthDay(new Date(newDate));
      this.tempTime.year = year;
      this.tempTime.month = month;
    },
    changeYear(count) {
      const oldDate = new Date(this.tempTime.year, this.tempTime.month);
      const newDate = oldDate.setFullYear(oldDate.getFullYear() + count);
      let [year] = getYearMonthDay(new Date(newDate));
      this.tempTime.year = year;
    }
  }
};
</script>

<style lang="scss">
@import "@/styles/_var.scss";
.zh-date-picker {
  border: 1px solid red;
  display: inline-block;
  .zh-date-content {
    position: absolute;
    z-index: 10;
    user-select: none;
    width: 280px;
    background: #fff;
    box-shadow: 1px 1px 2px $primary, -1px -1px 2px $primary;
    .zh-date-picker-header {
      height: 40px;
      display: flex;
      justify-content: space-between;
      align-items: center;
    }
  }
  .cell {
    width: 40px;
    height: 40px;
    display: inline-block;
    text-align: center;
    line-height: 40px;
  }
}
.cell {
  font-weight: 400;
}
.isNotCurrentMonth {
  color: #ccc;
}
.cell-dates:hover:not(.isNotCurrentMonth):not(.isSelect) {
  color: $primary;
}
.isSelect {
  color: #fff;
  background: $primary;
  border-radius: 50%;
}
.isToday {
  color: $primary;
  font-weight: bold;
  background: #fff;
}
</style>