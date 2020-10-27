## 304
last-modified  etag
if-modified-since  if-none-match
expires cache-control 
## gzip
accept-encoding content-encoding 

## referrer  referer
代表的资源的来源 （可以做安全判断）
可以在服务端用当前资源的host 和 referer 做对比如果不一致 说明这个资源就被其他网址所引用

如果你就想用别人 你可以把图片爬取下来，在去使用

/usr/hosts
C:\Windows\System32\drivers\etc

## 多语言 目前来说都是前端多语言  i18n
1.前端实现多语言
2.通过路径来实现多语言
3.通过请求来实现多语音 （header）

// Accept-Language: zh-CN,zh;q=0.9


## 正向代理和反向代理
- 如果代理服务器是帮助客户端的 就是正向代理
- 帮助服务器的就是方向代理
- webpack proxy 我发了一个请求 webpack
- cdn

> 正向代理 可以在请求的时候增加一些属性 权限认证 
> nginx （缓存）

虚拟主机 反向代理    ecs 服务  一个服务可以部署多个项目  多个域名
http-proxy
a.zf.cn -> 网站
b.zf.cn -> 网站

80服务器 => 3000
         => 4000