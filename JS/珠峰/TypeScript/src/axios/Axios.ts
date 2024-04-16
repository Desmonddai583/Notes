import {
  AxiosRequestConfig,
  AxiosResponse,
  InternalAxiosRequestConfig,
} from "./types";
import qs from "qs";
import parseHeader from "parse-headers";
import AxiosInterceptorManager, {
  Interceptor,
} from "./AxiosInterceptorManager";
class Axios {
  // 给Axios的实例增加 intercetpors, 并不是request方法
  public interceptors = {
    request: new AxiosInterceptorManager<InternalAxiosRequestConfig>(),
    response: new AxiosInterceptorManager<AxiosResponse>(),
  };
  //  axios中核心请求方法
  request<T>(config: AxiosRequestConfig): Promise<AxiosResponse<T>> {
    console.log(this.interceptors);

    const chain: (
      | Interceptor<InternalAxiosRequestConfig>
      | Interceptor<AxiosResponse>
    )[] = [{ onFulfilled: this.dispatchRequest }]; // 请求的真实逻辑

    this.interceptors.request.interceptors.forEach((interceptor) => {
      interceptor && chain.unshift(interceptor);
    });

    this.interceptors.response.interceptors.forEach((interceptor) => {
      interceptor && chain.push(interceptor);
    });

    let promise: Promise<AxiosRequestConfig | AxiosResponse> =
      Promise.resolve(config); // 我们构建一个每次执行后返回的promise

    // 通过promise链将所有的拦截器放在一起
    while (chain.length) {
      // (v:AxiosRequestConfig) => AxiosRequestConfig
      // (v:AxiosReponse) => AxiosReponse

      // AxiosRequestConfig -> AxiosResponse
      // AxiosResponse -> AxiosRequestConfig 会有问题
      const { onFulfilled, onRejected } = chain.shift()!;
      promise = promise.then(
        // 这个取出来的可能是请求拦截器 ， 也可能是响应拦截器
        onFulfilled as (v: AxiosRequestConfig | AxiosResponse) => any,
        onRejected
      );
    }
    return promise as Promise<AxiosResponse<T>>;
    // 发送请求需要对我们的配置进行合并，进行修改等操作
    // 1.对配置进行合并，默认值
    // 2.拦截器

    // 3.才是真正的发送请求
    // return this.dispatchRequest(config);
  }
  dispatchRequest<T>(config: AxiosRequestConfig): Promise<AxiosResponse<T>> {
    return new Promise((resolve, reject) => {
      let { url, method, params, headers, data, timeout } = config;
      // 创建一个ajax对象
      const request = new XMLHttpRequest();
      // params 是路径参数需要放到我们的url后面

      if (params) {
        if (typeof params === "object") {
          params = qs.stringify(params);
        }
        // /xxx?name=xxx&age=xxx
        url += (url!.includes("?") ? "&" : "?") + params;
      }
      request.open(method!, url!, true);
      // 请求头处理
      if (headers) {
        for (let key in headers) {
          request.setRequestHeader(key, headers[key]);
        }
      }
      request.responseType = "json";
      request.onreadystatechange = () => {
        // 请求发送成功了， status为0 表示请求未发送，请求（网络）异常
        if (request.readyState === 4 && request.status !== 0) {
          // 请求成功，而且状态码是200
          if (request.status >= 200 && request.status < 300) {
            let response: AxiosResponse<T> = {
              data: request.response || request.responseText,
              status: request.status,
              statusText: request.statusText,
              headers: parseHeader(request.getAllResponseHeaders()),
              config,
              request,
            };
            resolve(response);
          } else {
            reject(
              "my errorAxiosError: Request failed with status code " +
                request.status
            );
          }
        }
      };
      let requestBody: null | string = null;
      if (data) {
        requestBody = JSON.stringify(data);
      }
      if (timeout) {
        // 请求的超时时间
        request.timeout = timeout;
        request.ontimeout = function () {
          reject(`my errorAxiosError: timeout of ${timeout}ms exceeded`);
        };
      }
      request.onerror = function () {
        reject("net::ERR_INTERNET_DISCONNECTED");
      };

      if (config.cancelToken) {
        config.cancelToken.then((message) => {
          request.abort();
          reject(message);
          // 稍后用户会调用 source.cancel() 此promise就成功了
        });
      }

      request.send(requestBody); // 发送请求
    });
  }
}
export default Axios;
