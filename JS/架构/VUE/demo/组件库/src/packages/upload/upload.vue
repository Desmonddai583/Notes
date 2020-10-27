<template>
  <div class="zh-upload">
    <uploadDragger v-if="drag" :accept="accept" @file="uploadFiles"></uploadDragger>
    <template v-else>
      <div @click="handleClick" class="zh-upload-btn">
        <slot></slot>
      </div>
      <input
        type="file"
        :accept="accept"
        :multiple="multiple"
        @change="handleChange"
        :name="name"
        ref="input"
        class="input"
      />
    </template>

    <div>
      <slot name="tip"></slot>
    </div>
    <ul>
     
      <li v-for="file in files" :key="file.uid">
        <div class="list-item">
          <zh-icon icon="file"></zh-icon>
           <img :src="file.url" alt="">
          {{file.name}}
          <zh-progress v-if="file.status === 'uploading'" :percentage="file.percentage"></zh-progress>
          <zh-icon icon="cha"></zh-icon>
        </div>
      </li>
    </ul>
  </div>
</template>

<script>
import ajax from "./ajax";

import uploadDragger from "./upload-dragger.vue";
export default {
  name: "zh-upload",
  components: {
    uploadDragger
  },
  props: {
    name: {
      type: String,
      default: "file"
    },
    action: {
      type: String,
      required: true
    },
    fileList: {
      type: Array,
      default: () => []
    },
    accept: String,
    limit: Number,
    multiple: Boolean,
    onExceed: Function,
    onChange: Function,
    onSuccess: Function,
    onError: Function,
    onProgress: Function,
    beforeUpload: Function,
    // header + data
    httpRequest: {
      // 我会默认提供一个ajax  如果你传了会用你的
      type: Function,
      default: ajax
    },
    drag: {
      type: Boolean,
      default: false
    } // 面试的时候 让你设计一个组件 用户要要有哪些功能， 你需要暴露给用户哪些功能， 在考虑用户的行为
  },
  data() {
    return {
      tempIndex: 1,
      files: [], // 存储要展示的列表 ,可以在这里删除你要删除的文件 （询问一下用户是否要删除？）
      reqs: {}
    };
  },
  watch: {
    fileList: {
      immediate: true, // 立即执行处理海曙
      handler(fileList) {
        this.files = fileList.map(item => {
          item.uid = Date.now() + this.tempIndex++;
          item.status = "success";
          return item;
        });
      }
    }
  },
  methods: {
    handleClick() {
      // 在点击之前 先要还原输入框
      this.$refs.input.value = "";
      this.$refs.input.click();
    },
    handleStart(rawFile) {
      // 给文件生成一个唯一的id标示
      rawFile.uid = Math.random() + this.tempIndex++;
    
      let file = {
        // 我自己构建了一条文件信息
        status: "ready", // 默认准备上传
        name: rawFile.name, // 文件名子
        size: rawFile.size, // 上传图片的大小
        percentage: 0, // 上传的进度
        uid: rawFile.uid,
        raw: rawFile
      };
       file.url = URL.createObjectURL(rawFile); // 通过源文件创建一个路径 即可
      this.files.push(file); // 将当前用户上传的文件push到列表中，过一会要显示
      this.onChange && this.onChange(file);
    },
    getFile(rawFile) {
      return this.files.find(file => file.uid == rawFile.uid);
    },
    handleProgress(ev, rawFile) {
      // 给不同的状态
      // 通过源文件 用户上传的文件 -》 我格式化的结果
      let file = this.getFile(rawFile); // 这个file就是当前格式化化后的
      file.status = "uploading";
      file.percentage = ev.percent || 0; // 赋值上传进度
      this.onProgress(ev, rawFile); // 调用用户的回调
    },
    handleSuccess(res, rawFile) {
      let file = this.getFile(rawFile);
      file.status = "success";
      this.onSuccess(res, rawFile);
      this.onChange(file);
    },
    handleError(err, rawFile) {
      let file = this.getFile(rawFile);
      file.status = "fail";
      this.onError(err, rawFile);
      this.onChange(file);
      delete this.reqs[file.uid]; // 已经失败的ajax 不需要后续在中断请求了
    },
    post(rawFile) {
      // 真正的上传逻辑
      // 调用httpRequest方法
      // 需要整合一下参数 调用ajax 需要传递参数 ,处理上传的整个流程
      const uid = rawFile.uid; // 这里可能稍后上传的时候 会后悔 终端ajax 序号
      const options = {
        file: rawFile, // 源文件
        filename: this.name, // avatar
        action: this.action,
        onProgress: ev => {
          // 处理上传的中的状态
          this.handleProgress(ev, rawFile);
        },
        onSuccess: res => {
          // 处理成功的状态
          this.handleSuccess(res, rawFile);
        },
        onError: err => {
          // 处理失败时的状态
          this.handleError(err, rawFile);
        }
      };
      // req就是当前的请求
      let req = this.httpRequest(options);
      this.reqs[uid] = req; // 每个ajax 先存起来，稍后可以取消请求
      // 允许用户使用的是promise的ajax
      if (req && req.then) {
        req.then(options.onSuccess, options.onError);
      }
    },
    upload(rawFile) {
      // 上传文件
      // 先判断这个文件是否能够上传 没有任何限制直接上传即可
      if (!this.beforeUpload) {
        // 直接上传
        return this.post(rawFile);
      }
      // 否则需要调用用户的函数，获取他的返回值
      let flag = this.beforeUpload(rawFile);
      if (flag) {
        // 用户返回true 表示需要上传
        // 直接上传
        return this.post(rawFile);
      }
    },


    uploadFiles(files) { // 分片上传 断点续传 node时候 会实现
      // 限制上传是否达到最大条件
      if (this.limit && this.fileList.length + files.length > this.limit) {
        return this.onExceed && this.onExceed(files, this.fileList);
      }
      [...files].forEach(rawFile => {
        // 用户的文件 我需要做一些处理 可能用户频繁上传同一个文件
        // 将文件格式化成我想要的结果
        this.handleStart(rawFile); // 处理上传之前
        this.upload(rawFile); // 真正的上传
      });
    },
    handleChange(e) {
      // 获取选中的文件
      const files = e.target.files;
      // 多个文件如何上传 多创建几个ajax  一起传就ok
      this.uploadFiles(files);
    }
  }
};
</script>
<style lang="scss">
.zh-upload {
  .zh-upload-btn {
    display: inline-block;
  }
  .input {
    display: none;
  }
}
</style>