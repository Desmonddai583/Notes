// 对axios进行进一步的封装
import axios from 'axios'

// 配置默认请求的根地址
axios.defaults.baseURL = 'https://weixin.itzb.com/web/?lnj=api/';
// 配置超时时间...
axios.defaults.timeout = 10000;
// 请求之前的拦截
// 请求之后的拦截

export default {
  get(url = '', data = {}){
    return new Promise(function (resolve, reject) {
      axios.get(url, {
        params: data
      })
      .then(function (response) {
        resolve(response.data);
      })
      .catch(function (error) {
        reject(error);
      });
    });
  },
  post(url = '', data = {}){
    return new Promise(function (resolve, reject) {
      axios.get(url, data)
        .then(function (response) {
          resolve(response.data);
        })
        .catch(function (error) {
          reject(error);
        });
    });
  }
}


