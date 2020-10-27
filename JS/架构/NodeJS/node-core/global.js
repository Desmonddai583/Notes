// console.log(this); // this 不是global

// 模块化的概念 node中里面为了实现模块化给每个文件都包装了一个函数，这个函数中的this就被更改
// console.log(this === global); // false
// console.log(this === module.exports);

// console.log(Object.keys(global))
// global上拥有v8引擎上的方法

// process 进程
// 1)
// console.log(process.platform); // 进程运行的平台 win32 darwin
// 2)
// console.log(process.argv); // 当前进程执行时所带的参数  默认是数组类型参数前两个是固定的
// 1.当前node的执行命令文件
// 2.当前执行的文件是谁 node+文件执行时 可以传递参数 这些参数会放到 数组的第三项。。。
// 解析用户传递的参数
// node 4.node-core/global.js --port 3000 --config xxx
// let r = process.argv.slice(2).reduce((memo, current, index, arr) => {
//     if (current.startsWith('--')) {
//         memo[current.slice(2)] = arr[index + 1]
//     }
//     return memo
// }, {});
// const program = require('commander');
// program.name('node')
// program.usage('global.js')
// program.version('1.0.0')
// program.option('-p,--port <v>', 'please set you prot ')
// program.option('-c,--config <v>', 'please set  you config file ')
// program.command('create').action(() => { // 运行时会执行此方法
//     console.log('创建项目')
// })
// program.on('--help', function () {
//     console.log('\r\nRun command')
//     console.log('\r\n  node global -p 3000')
// })
// // vue create xxx
// let r = program.parse(process.argv)
// console.log(r)
// commander (TJ) yargs (webpack)
// 3)
// webpack 找配置文件，当前工作目录下查找
// console.log(process.cwd()); // current working directory  当前进程执行时的工作目录 http-server
// 4)
// 在当前命令行窗口下设置环境变量 window set命令 export命令  => cross-env
// console.log(process.env) // 当前进程的环境变量 会用他来区分各种环境
// cross-env env=development && node xxxx

// process.env process.cwd process.argv