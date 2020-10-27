import createApp from './app';

let {app} = createApp();
// 客户端拿到app后需要进行挂载
app.$mount('#app')


// 客户端打包出来的结果是js
// 服务端打包出来的结果是js文件-> 得到的是一个字符串
// 字符串返回给客户端 是一个html字符串，把客户端的js往上面一方
// 这里就拥有了js的逻辑