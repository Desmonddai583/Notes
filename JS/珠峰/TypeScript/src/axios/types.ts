import AxiosInterceptorManager from "./AxiosInterceptorManager";
import { CancelTokenStatic, isCancel } from "./CancelToken";

export type Methods =
  | "get"
  | "Get"
  | "post"
  | "POST"
  | "put"
  | "PUT"
  | "delete"
  | "DELETE";

// 取token的类型
export type CancelToken = ReturnType<CancelTokenStatic["source"]>["token"];
// 请求配置
export interface AxiosRequestConfig {
  url?: string;
  method?: Methods;
  params?: any;
  data?: Record<string, any>;
  headers?: Record<string, any>;
  timeout?: number;
  cancelToken?: CancelToken;
}
export interface InternalAxiosRequestConfig extends AxiosRequestConfig {
  headers: Record<string, any>;
}
// 响应的类型
export interface AxiosResponse<T = any> {
  data: T;
  status: number;
  statusText: string;
  headers: Record<string, any>;
  config: AxiosRequestConfig;
  request: XMLHttpRequest;
}

// 对应用户的axios的类型  == request方法

export interface AxiosInstance {
  <T = any>(config: AxiosRequestConfig): Promise<AxiosResponse<T>>;
  // 函数本身还有一些额外的方法，可以后续添加

  // 拦截器可以通过类来实现， 类既有类型 也有功能
  interceptors: {
    request: AxiosInterceptorManager<InternalAxiosRequestConfig>;
    response: AxiosInterceptorManager<AxiosResponse>;
  };
  CancelToken: CancelTokenStatic;
  isCancel: typeof isCancel;
}
