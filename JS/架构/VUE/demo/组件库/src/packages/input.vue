<template>
  <div class="zh-input" :class="inputClass">
    <zh-icon :icon="prefixIcon" v-if="prefixIcon"></zh-icon>
    <zh-icon :icon="suffixIcon" v-if="suffixIcon"></zh-icon>
    <input
      :type="showPassword?(passwordVisible?'text':'password'):type"
      :value="value"
      :placeholder="placeholder"
      :name="name"
      :disabled="disabled"
      @input="$emit('input',$event.target.value)"
      ref="input"
      @focus="$emit('focus',$event.target.value)"
      @blur="$emit('blur',$event.target.value)"
      @change="$emit('change',$event)"
    />
    <!-- @mousedown.native.prevent  不会失去焦点 -->
    <zh-icon
      icon="qingkong"
      v-if="clearable && value"
      @click.native="$emit('input','')"
      @mousedown.native.prevent
    ></zh-icon>
    <!-- 先失去焦点 在获取焦点 -->
    <zh-icon
      icon="eye"
      v-if="showPassword && value"
      @click.native="changeStatus"
    ></zh-icon>

    <!-- 
        zh-radio
        zh-checkbox
        zh-input
     -->
  </div>
</template>
<script>
export default {
  name: "zh-input",
  props: {
    name: {
      type: String,
      default: null
    },
    type: {
      type: String,
      default: "text"
    },
    placeholder: {
      type: String,
      default: "请输入内容"
    },
    value: {
      type: String,
      default: ""
    },
    disabled: {
      type: Boolean,
      default: false
    },
    clearable: {
      type: Boolean,
      default: false
    },
    showPassword: {
      type: Boolean,
      default: false
    },
    prefixIcon: String,
    suffixIcon: String
  },
  data() {
    return { passwordVisible: false };
  },
  computed: {
    inputClass() {
      let classes = [];
      if (this.clearable || this.showPassword || this.suffixIcon) {
        classes.push(`zh-input-suffix-icon`);
      }
      if (this.prefixIcon) {
        classes.push(`zh-input-prefix-icon`);
      }
      return classes;
    }
  },
  methods: {
    changeStatus() {
      this.passwordVisible = !this.passwordVisible;
      this.$nextTick(() => {
        this.$refs.input.focus();
      });
    }
  }
};
</script>

<style lang="scss">
@import "@/styles/_var.scss";
.zh-input {
  display: inline-flex;
  position: relative;
  input {
    padding: 8px;
    width: 150px;
    height: 42px;
    border-radius: 4px;
    border: 1px solid #dcdfe6;
    &:focus {
      border: 1px solid $primary;
      outline: none;
      box-shadow: inset -1px 0px 2px $primary, inset 1px 1px 1px $primary;
    }
    &[disabled] {
      cursor: not-allowed;
      background: #eee;
    }
  }
}
.zh-input-suffix-icon {
  input {
    padding-right: 25px;
  }
  .zh-icon {
    right: 8px;
    top: 13px;
    position: absolute;
    cursor: pointer;
    width: 14.5px;
    height: 14.5px;
  }
}
.zh-input-prefix-icon {
  input {
    padding-left: 25px;
  }
  .zh-icon {
    left: 8px;
    top: 13px;
    position: absolute;
    cursor: pointer;
    width: 14.5px;
    height: 14.5px;
  }
}
</style>