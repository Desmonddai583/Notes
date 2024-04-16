import axios, {
  AxiosRequestConfig,
  AxiosResponse,
  InternalAxiosRequestConfig,
} from "./axios";
// 基础路径 访问的后台路径
const baseURL = "http://localhost:8080";
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
  headers: {
    "Content-Type": "application/json",
    name: "", // 用来交给拦截器来做处理
  },
};

// 希望在请求的时候 可以对我们的请求参数进行处理
// use方法用来注册我们的拦截器

// [c,b]  [a,c] request
let r1 = axios.interceptors.request.use(
  (config: InternalAxiosRequestConfig) => {
    config.headers.name += "a";
    return config;
  }
);
axios.interceptors.request.use((config: InternalAxiosRequestConfig) => {
  config.headers.name += "b";
  return config;
});
axios.interceptors.request.use((config: InternalAxiosRequestConfig) => {
  return new Promise((resolve, reject) => {
    setTimeout(() => {
      config.headers.name += "c";
      resolve(config); // 我们的拦截可以用promise作为返回值，返回config或者reponse
    }, 3000);
  });
  //   return Promise.reject("配置出错");
});
axios.interceptors.request.eject(r1);
axios.interceptors.response.use((response) => {
  response.data.name += "a";
  return response;
});
let r2 = axios.interceptors.response.use((response) => {
  response.data.name += "b";
  return response;
});
axios.interceptors.response.use((response) => {
  response.data.name += "c";
  return response;
});
axios.interceptors.response.eject(r2);
axios(requestConfig)
  .then((response: AxiosResponse<Person>) => {
    console.log(response.data.name);
    return response.data;
  })
  .catch((error: any) => {
    console.log("error" + error);
  });

// 拦截器执行过程
// 请求 拦截3
// 请求 拦截2
// 请求 拦截1
// 核心的请求方法 axios.request
//
