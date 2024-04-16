import axios, { AxiosRequestConfig, AxiosResponse } from "./axios";
// 基础路径 访问的后台路径
const baseURL = "http://localhost:8080";
// 发送get请求和post请求
interface Person {
  name: string;
  age: number;
}
let person: Person = { name: "jw", age: 30 };
let requestConfig: AxiosRequestConfig = {
  url: baseURL + "/post_timeout?timeout=3000",
  method: "post",
  //   params: person, http特性协商数据
  data: person,
  headers: {
    "Content-Type": "application/json",
  },
  timeout: 1000,
};
// 希望的返回值也是Person

axios(requestConfig)
  .then((response: AxiosResponse<Person>) => {
    console.log(response.data);

    return response.data;
  })
  .catch((error: any) => {
    console.log("error" + error);
  });

// 失败有几种情况？
// 1.网络挂了
// 2.根据状态码来决定失败
// 3.超时处理
