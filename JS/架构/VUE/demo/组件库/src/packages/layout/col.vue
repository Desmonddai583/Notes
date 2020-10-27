<template>
  <div class="zh-col" :class="colClass" :style="colStyle">
    <slot></slot>
  </div>
</template>

<script>
export default {
  name: "zh-col",
  data() {
    return { gutter: 0 };
  },
  props: {
    span: {
      type: Number,
      default: 24
    },
    offset: {
      type: Number,
      default: null
    },
    xs: [Number, Object],
    sm: [Number, Object],
    md: [Number, Object],
    lg: [Number, Object],
    xl: [Number, Object]
  },
  computed: {
    colClass() {
      // 统一管理我们的样式
      let classes = [];
      classes.push(`zh-col-${this.span}`);
      if (this.offset) {
        // 说明用户传入了偏移量
        classes.push(`zh-col-offset-${this.offset}`);
      }
      ["xs", "sm", "md", "lg", "xl"].forEach(type => {
        if (typeof this[type] === "object") {
          let { span, offset } = this[type];
          span && classes.push(`zh-col-${type}-${span}`); // zh-col-xs-1
          offset && classes.push(`zh-col-${type}-offset-${offset}`); // zh-col-xs-offset-1
        } else {
          this[type] && classes.push(`zh-col-${type}-${this[type]}`); // zh-col-xs-1
        }
      });
      return classes;
    },
    colStyle() {
      let style = {};
      if (this.gutter) {
        style = {
          ...style,
          paddingLeft: this.gutter / 2 + "px",
          paddingRight: this.gutter / 2 + "px"
        };
      }
      return style;
    }
  }
};
</script>

<style lang="scss">
@import '@/styles/_var.scss';
// 需要通过循环24 来创造出不同的宽度
@for $i from 1 through 24 {
  .zh-col-#{$i} {
    width: $i/24 * 100%;
  }
  .zh-col-offset-#{$i} {
    margin-left: $i/24 * 100%;
  }
}

@include res(xs) {
  @for $i from 1 through 24 {
    .zh-col-xs-#{$i} {
      width: $i/24 * 100%;
    }
    .zh-col-xs-offset-#{$i} {
      margin-left: $i/24 * 100%;
    }
  }
}
@include res(sm) {
  @for $i from 1 through 24 {
    .zh-col-sm-#{$i} {
      width: $i/24 * 100%;
    }
    .zh-col-sm-offset-#{$i} {
      margin-left: $i/24 * 100%;
    }
  }
}
@include res(md) {
  @for $i from 1 through 24 {
    .zh-col-md-#{$i} {
      width: $i/24 * 100%;
    }
    .zh-col-md-offset-#{$i} {
      margin-left: $i/24 * 100%;
    }
  }
}
@include res(lg) {
  @for $i from 1 through 24 {
    .zh-col-lg-#{$i} {
      width: $i/24 * 100%;
    }
    .zh-col-lg-offset-#{$i} {
      margin-left: $i/24 * 100%;
    }
  }
}
@include res(xl) {
  @for $i from 1 through 24 {
    .zh-col-xl-#{$i} {
      width: $i/24 * 100%;
    }
    .zh-col-xl-offset-#{$i} {
      margin-left: $i/24 * 100%;
    }
  }
}
</style>