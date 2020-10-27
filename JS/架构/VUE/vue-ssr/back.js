// 需要node的模块规范 import export
// require  module.exports
const Koa = require('koa'); // 引入koa
const Router = require('koa-router');
const app = new Koa(); // 创建一个应用
const router = new Router(); // 产生一个路由系统
const Vue = require('vue');
const vm = new Vue({
    data(){
        return {name:'zf',age:10}
    },
    template:`
        <div>
            <p>{{name}}</p>
            <span>{{age}}</span>
        </div>
    `
});
const fs = require('fs'); // node中的内置模块 可以读取文件
const path = require('path'); // node中的内置模块 用来操作路径的
// 使用的html模板
const template = fs.readFileSync(path.resolve(__dirname,'template.html'),'utf8');
const VueServerRenderer = require('vue-server-renderer'); // vue的服务端渲染包
const render = VueServerRenderer.createRenderer({
    template
}); // 创建一个渲染器
router.get('/',async (ctx)=>{ // 当访问/时 请求是get方法 可以执行对应的回调
    ctx.body = await render.renderToString(vm)
})
app.use(router.routes()); // 使用路由系统
app.listen(3000); // 监听3000端口

// 每次修改服务端代码 都需要重启服务器
// code runner
// npm install nodemon -g
// nodemon back.js