export default {
  fmtTime:function (time) {
    time = time || 0;
    // 计算小时
    let h = parseInt(time / (60 * 60) % 24);
    // 计算分钟
    let m = parseInt(time / 60  % 60);
    // 计算秒钟
    let s = parseInt(time % 60);

    // 对数据进行二次处理
    let obj = {
      hour: (h < 10 ? "0"+ h : h),
      min: (m < 10 ? "0"+ m : m),
      sec: (s < 10 ? "0"+ s : s),
    };

    return obj;
  }
}
