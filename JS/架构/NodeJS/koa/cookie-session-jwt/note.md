## cookie session (localStorage sessionStorage)
- http 无状态的 （cookie 后端设置 前端来设置）

## jwt / session 来实现登录功能
- jwt 表示不需要再服务端存储任何信息 
- 每次你访问服务器的时候 服务器会通过秘钥 生成一个token （令牌）
- 浏览器再次访问服务器时 带上这个令牌

- cookie签名