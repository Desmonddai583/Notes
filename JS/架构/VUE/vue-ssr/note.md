## 服务端渲染 ssr
- 浏览器里进行渲染 ,服务端渲染 在服务端将对应的数据请求完，在后端拼装好页面返回给前端 
- 客户端渲染不利于SEO优化,服务端渲染的结果可以被浏览器抓取到
- SSR 缺陷就是占用大量cpu和内存
- 客户端渲染可能会出现白屏，通过ssr 可以减少白屏事件
- API不能用 只支持beforeCreate created

- npm init -y
- npm install vue vue-router vuex vue-server-renderer(vue 服务端渲染插件)
- npm install koa(node的框架) koa-router(后端路由) koa-static(后端返回的静态页面)


## webpack 主要就是打包文件用的 
- 模块规范也是node中的语法


- webpack(核心打包用) webpack-cli(解析命令行参数)
- webpack-dev-server (在开发环境下帮我们提供一个开发环境 支持更新)
- babel-loader (webpack和babel的一个桥梁) @babel/core(babel的核心模块) @babel/preset-env(可以把高级语法转换成es5语法)
- vue-style-loader(vue解析样式 插入到页面中) css-loader
- vue-loader vue-template-compiler
- html-webpack-plugin

- webpack-merge 合并webpack配置的

Vue SSR 指南: https://ssr.vuejs.org/zh/guide/ 