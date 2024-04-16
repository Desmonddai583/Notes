import axios, { AxiosRequestConfig, AxiosResponse } from "./axios";
// 基础路径 访问的后台路径
const baseURL = "http://localhost:8080";

const CancelToken = axios.CancelToken;
const source = CancelToken.source(); // 创建一个token和取消方法

// 发送get请求和post请求
interface Person {
  name: string;
  age: number;
}
let person: Person = { name: "jw", age: 30 };
let requestConfig: AxiosRequestConfig = {
  url: baseURL + "/post",
  method: "post",
  data: person,
  cancelToken: source.token, // 取消的token
};

axios(requestConfig)
  .then((response: AxiosResponse<Person>) => {
    console.log(response.data.name);
    return response.data;
  })
  .catch((error: any) => {
    if (axios.isCancel(error)) {
      return console.log("是取消的错误", error);
    }

    console.log("error" + error);
  });

source.cancel("我不想请求了"); // 我们想取消操作

// 拦截器执行过程
// 请求 拦截3
// 请求 拦截2
// 请求 拦截1
// 核心的请求方法 axios.request
//
