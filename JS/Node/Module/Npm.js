// npm  node package manager
// http-server anywhere
// npm库 帮我们将我们的包上传到网上


// 第三方模块

// 我们下载的模块 不需要加./ 引得是 module.paths

// 安装 卸载 发布
// 安装前 npm init -y,初始化前先关心当前文件夹 不能有中文 特殊字符串 不能用要安装的模块来命名

// 初始化一个package.json 不能写注释 不能加标点
// 如果没有初始化，记录依赖的功能就没了

// 默认我们会区分 开发的依赖
// 开发依赖 webpack babel 
// 项目依赖 react redux


// npm install jquery@1.8.3
// npm install babel-core --save-dev


// npm uninstall jquery
// npm uninstall babel-core --save-dev


// 当文件丢了 想重新安装依赖
// npm install --production 不包含开发依赖


// yarn (不稳定)
// 全局命令 再命令行下使用 按到哪去了
// npm root -g
// npm install -g yarn 如果mac需要加sudo 
// yarn init -y
// yarn add 文件名@1.8.3 --dev
// yarn remove 文件名
// yarn install

// npm config list
// npm的配置文件 可以更改下载的来源 和下到什么位置 代理配置
// npm set prefix 设置安装的路径

// 切换源 taobao cnpm 
// npm install nrm -g
// nrm use taobao


// 全局安装 发布包(必须要有package.json)
// 通过命令行发布包
// npm adduser 如果有账号相当于是登录 没有就是注册 
// 账号只能再官方登录
// npm publish

// 全局安装
// npm link 可以把当前文件夹链接到全局目录下
// 好处就是边开发边测试
// 配置package.json 下的bin参数


// npm install / npm add