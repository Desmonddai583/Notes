// 维护一个数组 用来存放用户的get方法
// 等会请求到来时 依次查找
const http = require('http');
const url = require('url');
let routers = [{ // 默认路由
    path: '*',
    method: 'all',
    handler(req, res) {
        res.end(`Cannot ${req.method} ${req.url}  my`)
    }
}]
function createApplication() {
    return {
        get(path,handler) {
            routers.push({
                path,
                method:'get',
                handler
            })
        },
        listen() {
            // 创建一个http服务器
            let server = http.createServer((req,res)=>{
                let {pathname} = url.parse(req.url);
                let m = req.method.toLowerCase();
                for(let i = 1; i< routers.length;i++){
                    let {path,method,handler} = routers[i];
                    if(path === pathname && method === m){
                        return handler(req,res)
                    }
                }
                routers[0].handler(req,res)
            });
            server.listen(...arguments);
        }
    }
}
module.exports = createApplication;