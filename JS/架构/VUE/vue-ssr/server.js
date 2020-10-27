const Koa = require('koa');
const Router = require('koa-router');
const fs = require('fs');
const path = require('path');
const static = require('koa-static');

const ServerRenderer = require('vue-server-renderer')

let app = new Koa();
let router = new Router();

// 可以采用字符串的方式
let template = fs.readFileSync(path.resolve(__dirname, 'dist/server.html'), 'utf8');
// let ServerBundle = fs.readFileSync(path.resolve(__dirname,'dist/server.bundle.js'),'utf8');
let ServerBundle = require('./dist/vue-ssr-server-bundle.json')
let clientManifest = require('./dist/vue-ssr-client-manifest.json');

// 表示渲染时使用我自己webpack服务端构建出来的包,并且和他说这里客户端引用的是对应的manifest文件
let render = ServerRenderer.createBundleRenderer(ServerBundle, {
    template,
    clientManifest
})
router.get('/', async ctx => {
    ctx.body = await new Promise((resolve, reject) => {
        render.renderToString({url:'/'}, (err, data) => { // 解析css 必须写成回调的方式
            if (err) {
                console.log(err);
                reject(err);
            } else {
                resolve(data);
            }
        })
    })
})
app.use(static(path.resolve(__dirname, 'dist'))); // 告诉静态页以哪个目录来显示
app.use(router.routes());
// to...


/// 最终
router.get('*', async ctx => {
    try {
        ctx.body = await new Promise((resolve, reject) => {
            render.renderToString({url:ctx.path},(err, data) => {
                if (err) {
                    console.log(err);
                    reject(err);
                } else {
                    resolve(data);
                }
            })
        })
    } catch (e) {
        ctx.body = 'page not found'
    }
})
app.listen(3000);