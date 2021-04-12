gogs是一个可以媲美gitlab等软件的自主git服务。go开发，轻便、部署

https://github.com/gogs/gogs

使用docker 安装
docker pull gogs/gogs

docker run --name=gogs -p 10022:22  -d  \
  -p 3000:3000 -v /home/shenyi/gogs:/data \
  gogs/gogs

可以自行注册个用户,第一个注册的用户：自动就是管理员
