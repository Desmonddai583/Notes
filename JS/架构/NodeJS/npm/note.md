## npm 的使用方式
- node package manger

## 全局模块(在命令行的任何地方可以使用) 局部模块
- 为什么全局模块可以直接在任何地方使用

## 全局的模块
- 必须使用package.json 中配置bin参数
- #! /usr/bin/env node

## npm link
就是将当前的目录临时的放到全局下 放标调试


## 本地安装  (--save -S / --save-dev -D)
- npm install webpack --save-dev
- --save-dev 代表的是开要使用
- --save 是开发上线时都需要
- npm uninstall webpack

## github / npm


## npm版本号管理的问题
semver规范 规定了版本号 由3位组成  MAJOR MINOR  PATCH
- MAJOR 可能不在兼容老版本
- MINOR 新增了一些兼容旧版本的api vue.observable
- PATCH 修复bug

> 都是git的tag 对应着npm的版本


```bash
npm version major minor patch
```

> 会自动和git进行关联

## 版本号含义
2.2.0  必须是2.2.0
^2.2.0   限定大版本，后面更新只要不超过2尽可以
~2.2.0   限定前两个版本，后面的版本只要比0大就可以
>=2.0   大于这个版本
<=2.0
1.0.0 - 2.0.0

预发版本
alpha 预览版 内部测试版
beta  测试版 公开测试版
rc    最终测试版本


## scripts
- 可以配置脚本的命令 快捷键(可以把很长的命令放到scripts中)
- 执行命令  会将当前的node_modules目录下的.bin文件夹放到全局中(所以可以直接使用) 
- npm run start 可以简写成 npm start

## npx
- npx和script一致可以帮我们直接运行 .bin目录下的内容
- 如果.bin目录下存在 会执行对应脚本，如果不存在会下载运行

> npx 只是一个临时的使用方案。 npm5.2 之后产生的


## 源的切换 (npm nrm nvm)
- npm install nrm -g
- nrm ls / nrm use


## 包的发布 
- 如何发布一个包 先注册npm账号
- 一定要在官方源上发
- npm addUser 添加用户
- npm publish 发布包