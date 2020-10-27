<template>
  <div class="zh-popover">
    <div
      class="zh-popover-content"
      :class="`content-${placement}`"
      v-if="visible"
      ref="content"
      @click.stop
    >
      <h3 v-if="title">{{title}}</h3>
      <slot>{{content}}</slot>
      <div class="arrow"></div>
    </div>
    <slot name="reference"></slot>
  </div>
</template>
<script>
const on = (element, event, handler) => {
  element.addEventListener(event, handler, false);
};
const off = (element, event, handler) => {
  element.removeEventListener(event, handler, false);
};
export default {
  name: "zh-popover",
  props: {
    value: {
      default: false,
      type: Boolean
    },
    placement: {
      validator(type) {
        if (!["top", "bottom", "left", "right"].includes(type)) {
          throw new Error(
            "属性必须是" + ["top", "bottom", "left", "right"].join("、")
          );
        }
        return true;
      }
    },
    width: {
      type: String
    },
    title: {
      type: String
    },
    content: {
      type: String
    },
    trigger: {
      type: String // click/hover
    }
  },
  data() {
    return { visible: false };
  },
  watch: {
      visible(value){
          this.$emit('input',value)
      },
    value: {
      immediate: true,
      handler(value) {
        this.visible = value;
        if (value) {
          // 显示
          this.$nextTick(() => {
            let content = this.$refs.content;
            document.body.appendChild(content);
            if (this.trigger == "hover") {
              on(content, "mouseenter", this.handleMouseEnter);
              on(content, "mouseleave", this.handleMouseLeave);
            }
          });
        }
      }
    }
  },
  methods: {
    toggle() {
      this.visible = !this.visible;
    },
    handleDocumentClick(e) {
      if (this.$el.contains(e.target)) {
        return false;
      }
      this.visible = false;
    },
    handleMouseEnter() {
      clearTimeout(this.timer);
      this.visible = true;
    },
    handleMouseLeave() {
      this.timer = setTimeout(() => {
        this.visible = false;
      }, 200);
    }
  },
  mounted() {
    // 要绑定事件了
    let reference = this.$slots.reference;
    if (reference) {
      this.reference = reference[0].elm;
    }
    if (this.trigger == "hover") {
      // 针对不同触发方法做相对的处理
      on(this.$el, "mouseenter", this.handleMouseEnter);
      on(this.$el, "mouseleave", this.handleMouseLeave);
    } else if (this.trigger === "click") {
      on(this.reference, "click", this.toggle);
      on(document, "click", this.handleDocumentClick);
    }
  },
  beforeDestroy() {
    off(this.$el, "mouseenter", this.handleMouseEnter);
    off(this.$el, "mouseleave", this.handleMouseLeave);
    off(this.reference, "click", this.toggle);
    off(document, "click", this.handleDocumentClick);
  }
};
</script>
<style lang="scss">
.zh-popover {
  display: inline-block;
  position: relative;
}
.zh-popover-content {
  position: absolute;
  top: 100px;
  left: 100px;
  padding: 10px;
  border-radius: 4px;
  z-index: 10;
  box-shadow: -1px -1px 3px #ccc, 1px 1px 3px #ccc;
  background: #fff;
}
.arrow {
  position: absolute;
}
.arrow::before,
.arrow::after {
  content: "";
  display: block;
  width: 0;
  height: 0;
  border: 6px solid #ccc;
  border-left-color: transparent;
  border-right-color: transparent;
  border-top-color: transparent;
  position: absolute;
}
.arrow::after {
  border-bottom-color: #fff;
  transform: translateY(1px);
  filter: drop-shadow(0 -2px 1px #ccc);
}
.content-top {
  .arrow {
    left: 50%;
    margin-left: -6px;
    bottom: 0px;
    &::after,
    &::before {
      transform: rotate(180deg);
    }
  }
}
.content-bottom {
  .arrow {
    left: 50%;
    margin-left: -6px;
    top: -12px;
  }
}
.content-left {
  .arrow {
    top: 50%;
    margin-top: -6px;
    right: 0px;
    &::after,
    &::before {
      transform: rotate(90deg);
    }
  }
}
.content-right {
  .arrow {
    top: 50%;
    margin-top: -6px;
    left: -12px;
    &::after,
    &::before {
      transform: rotate(-90deg);
    }
  }
}
</style>