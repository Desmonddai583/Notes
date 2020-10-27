const http = require('http');
const path = require('path');
const fs = require('fs').promises;
const url = require('url');
const mime = require('mime');
const ejs = require('ejs');
const crypto = require('crypto');
const zlib = require('zlib');
const {
    promisify
} = require('util');
// 可以统一将异步方法全部转化成promise
let renderFile = promisify(ejs.renderFile)





const {
    createReadStream,
    readFileSync
} = require('fs');

const merge = (config) => {
    return {
        port: 3000,
        directory: process.cwd(),
        ...config
    }
}
class Server {
    constructor(config) {
        this.config = merge(config);
    }
    async handleRequest(req, res) {
        // 处理是文件还是文件夹 
        let {
            pathname
        } = url.parse(req.url);
        pathname = decodeURIComponent(pathname); // 对路径进行解码

        // 为什么要有服务端渲染 
        // vue react 单页应用  webpack -> js 文件 500k <div id="app"></div> seo
        // 服务端渲染 我直接返回一个字符串 (包含了完整的html和内容)  seo
        // 博客 新闻类 文章类  
        let absPath = path.join(this.config.directory, pathname);
        try {
            let statObj = await fs.stat(absPath);
            if (statObj.isFile()) {
                // 如果是文件 需要读取文件中的内容
                this.sendFile(req, res, absPath, statObj);
            } else {
                // 文件夹
                let arr = await fs.readdir(absPath);
                // 我们需要根据这个dirs 生成一个html字符串 将他渲染到页面上
                // underscore handlebars jade ejs nunjucks

                // 需要单独处理一下 点击的路径 
                let dirs = arr.map(item => {
                    return { // 需要处理点击时增加父路径 否则相对的都是根路径
                        path: path.join(pathname, item), // /  /index.js
                        dir: item
                    }
                });
                let r = await renderFile(path.resolve(__dirname, 'template.html'), {
                    arr: dirs
                });
                res.setHeader('Content-Type', 'text/html;charset=utf-8')
                res.end(r);
            }
        } catch (e) {
            this.sendError(req, res, e);
        }
    }
    async cache(req, res, absPath, statObj) {
        // 1.强制缓存服务端可以设置 当前请求发送完毕后 如果再发送请求，我可以设置在某段时间之内不会在像服务端发起请求，去浏览器缓存中查找 
        // 2.对比缓存就是 服务端和浏览器的文件做一个对比 判断一下是否需要进行缓存, last-modified 不精准的问题，可以使用etag 指纹（独一无二的）
        // expires 过期时间 是一个绝对的时间  Cache-control
        res.setHeader('Expires', new Date(Date.now() + 10 * 1000).toGMTString());
        // no-cache 表示浏览器有缓存 但是请求时会请求服务器
        // no-store 表示浏览器没缓存  
        // 首页必须要发送请求 首页引用的资源 可以实现强制缓存
        // 如果10s 内 文件发生变化了 需要返回最新的文件
        res.setHeader('Cache-control', 'no-cache'); // 强制缓存 会导致文件更新，显示可能不是最新的
        // 可以显示最新的内容
        let fileContent =  await fs.readFile(absPath);
        let ifNoneMatch = req.headers['if-none-match'];
        let ifModifiedSince = req.headers['if-modified-since']; // 浏览器给我的

        // 比对文件是否发生了变化
        let ctime = statObj.ctime.toGMTString();
        let etag = crypto.createHash('md5').update(fileContent).digest('base64')

        res.setHeader('Last-Modified', ctime); // 我给浏览器设置的
        res.setHeader('Etag', etag);
        let flag = true;
        // 先走强制缓存  - 走对比缓存 （比较指纹 比较最后修改时间 都符合 就说明文件没有修改）
        if (ifNoneMatch !== etag) { // 不会直接取完整的etag 
            return false;
        }
        if (ctime !== ifModifiedSince) { // 如果不一致则返回新文件，如果时间一致 则找浏览器缓存
            return false;
        }
        return flag;
    }
    async sendFile(req, res, absPath, statObj) {
        let cache = await this.cache(req, res, absPath, statObj);
        if (cache) {
            // 服务器告诉浏览器你走缓存
            res.statusCode = 304;
            res.end();
            return;
        }
        // 判断是否要压缩
        res.setHeader('Content-Type', mime.getType(absPath) || 'text/plain' + ';charset=utf-8');
        let gzip = this.gzip(req, res, absPath, statObj); // 转化流
        if(gzip){
         
            createReadStream(absPath).pipe(gzip).pipe(res); // transform
        }else{
            createReadStream(absPath).pipe(res);
        }
    }
    // gzip 压缩 是文件的重复性越高 压缩越多

    // 视频 图片 不需要gzip压缩的
    gzip(req, res, absPath, statObj){
        // 浏览器会告诉服务端 我能做哪些压缩 服务器会根据浏览器的支持情况 做对应的压缩处理
        let encoding = req.headers['accept-encoding'];
        if(encoding.includes('gzip')){
            res.setHeader('Content-Encoding','gzip')
            return zlib.createGzip()
        }else if(encoding.includes('deflate')){
            res.setHeader('Content-Encoding','deflate')

            return zlib.createDeflate();
        }
        return false;
    }
    sendError(req, res, e) {
        console.log(e);
        res.statusCode = 404;
        res.end('Not Found');
    }
    start() { // 当前实例
        // 如果不进行bind this默认是http.createServer
        let server = http.createServer(this.handleRequest.bind(this));
        server.listen(this.config.port);
    }
}
module.exports = Server;
// 静态文件的缓存 压缩  304缓存 gzip
// http部分 细小的头header 过一下 开始koa



// <!-- 如果有 js语法需要使用<%%> -->
// <!-- <%=> -->
// <!-- <%-> -->
// <!-- include-->
// <%=html%>