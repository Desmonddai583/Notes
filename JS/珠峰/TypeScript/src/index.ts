// // vue  ref() -> xxx.value   unref()

// let props = {
//   name: "jw",
//   age: 30,
// };

// interface Proxy<T> {
//   get(): T;
//   set(newVal: T): void;
// }
// type Proxify<T> = {
//   [K in keyof T]: Proxy<T[K]>;
// };
// function proxify<T>(props: T): Proxify<T> {
//   let result = {} as Proxify<T>; // 装包后的对象
//   for (let key in props) {
//     let oldValue = props[key];
//     result[key] = {
//       get() {
//         return oldValue;
//       },
//       set(newVal) {
//         oldValue = newVal;
//       },
//     };
//   }
//   return result;
// }

// let proxyProps = proxify(props);

// proxyProps.name.get();
// proxyProps.name.set("abc");

// function unProxify<T>(props: Proxify<T>): T {
//   let result = {} as T;
//   for (let key in props) {
//     let value = props[key];
//     result[key] = value.get();
//   }
//   return result;
// }

// let oldProps = unProxify(proxyProps);
// oldProps.age;

import axios, {
  AxiosInstance,
  AxiosRequestConfig,
  AxiosResponse,
  InternalAxiosRequestConfig,
} from "axios";

// 如果是复杂的项目，我们一般都会采用每个请求都是相互独立的， 每个请求都创建一个实例

export interface ResponseData<T = any> {
  code: number; // 来判断请求的成功与否
  data?: T;
  message?: string;
}
class HttpRequest {
  public baseURL = "http://localhost:3000";
  public timeout = 3000;
  public requestQueue = new Set();
  public tokens = new Set();
  // 图片处理  ， 上传请求
  mergeConfig(requestConfig: AxiosRequestConfig) {
    return Object.assign(
      {
        baseURL: this.baseURL,
        timeout: this.timeout,
      },
      requestConfig
    );
  }
  withInterceptors(instance: AxiosInstance) {
    let requestUrl: string = "";
    instance.interceptors.request.use((config: InternalAxiosRequestConfig) => {
      // 记录当前正在发送的请求，入队列
      config.headers.token = "my token"; // 增加token
      requestUrl = config.url!;
      this.requestQueue.add(requestUrl);
      return config;
    });
    instance.interceptors.response.use(
      (response: AxiosResponse<ResponseData>) => {
        // res.data.data
        // 记录当前正在发送的请求，入队列
        // 处理状态码
        // response.data 根据返回的数据对响应做处理

        if (response.data.code === 401) {
          //
          return Promise.reject("请求处理失败");
        }

        this.requestQueue.delete(requestUrl);
        return response;
      },
      (err) => {
        this.requestQueue.delete(requestUrl);
        return Promise.reject(err);
      }
    );
  }
  public getAllTokens() {
    return this.tokens;
  }
  public request(requestConfig: AxiosRequestConfig) {
    const CancelToken = axios.CancelToken;
    const source = CancelToken.source();
    const instance = axios.create();
    const cancelToken = source.token;
    const requestOptions = this.mergeConfig({
      cancelToken: cancelToken,
      ...requestConfig,
    });
    this.tokens.add(cancelToken);
    this.withInterceptors(instance);

    // 拿到的是请求后的数据
    return instance(requestOptions) as Promise<ResponseData>; // 真正的发请求
  }

  get<T = any>(url: string, config: any): Promise<ResponseData<T>> {
    return this.request({
      method: "get",
      url,
      params: config,
    });
  }
  post<T = any>(url: string, data: any): Promise<ResponseData<T>> {
    return this.request({
      method: "post",
      url,
      data,
    });
  }
}
// 通过promise来进行装包和拆包
const http = new HttpRequest();
http
  .get<{ name: string; age: string }>("/getUser", {
    id: "100",
  })
  .then((data) => {
    // data.
  });
// axios.request()
// axios.get()
// axios.post();
// 拦截器
