import Axios from "./Axios";
import { CancelTokenStatic, isCancel } from "./CancelToken";
import { AxiosInstance } from "./types";

function createInstance() {
  // 1.创建类的实例
  const context = new Axios();

  // 2.获取request方法，并且让request中的this永远执行类的实例
  let instance = Axios.prototype.request.bind(context);
  // context.interceptors.request.use
  // context.interceptors.response.use
  instance = Object.assign(instance, context);
  // 3.返回request方法
  return instance as AxiosInstance;
}

const axios = createInstance();
// 需要将编写好的代码赋予给CancelToken
axios.CancelToken = new CancelTokenStatic();
axios.isCancel = isCancel;
export default axios;

// 导出所有类型
export * from "./types";
