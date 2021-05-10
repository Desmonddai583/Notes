常见的压测
  1、LoadRunner （商业版收费）
  2、Jmeter 
  3、Wrk、apache ab、hey 等等
  4、Locust+boomer （本篇主题）
  5、阿里云等云压测（人民币开道）

Locust
  开源负载测试工具。使用 Python 代码定义用户行为，也可以仿真百万个用户https://www.locust.io/

Boomer
  一个用Go写的slave端
  https://github.com/myzhan/boomer

  安装：
    1、go get github.com/myzhan/boomer
    2、go get  github.com/zeromq/gomq 

服务端部署
  docker pull locustio/locust
  文档 https://docs.locust.io/en/stable/running-locust-docker.html

  启动
    由于slave用GO写的。因此locustfile就随便搞搞，没用

    1、创建一个文件夹 locust 创建一个d.py 
    2、启动
      docker run -d --name locust \
      -p 8089:8089  \
      -p 5557:5557 \
      -v /home/shenyi/locust:/app \
      -w /app \
      locustio/locust \
        -f a.py --master -H http://0.0.0.0:8089

slave执行
  go run main.go --master-host=192.168.29.135  --master-port=5557

基本参数
  Number of users to simulate：设置模拟的用户总数
  Hatch rate (users spawned/second)：每秒启动的虚拟用户数
  Start swarming：执行locust脚本

参数指标
  Type：请求类型，即接口的请求方法；
  Name：请求路径；
  requests：当前已完成的请求数量；
  fails：当前失败的数量；
  Median：响应时间的中间值，即50%的响应时间在这个数值范围内，单位为毫秒；
  Average：平均响应时间，单位为毫秒；
  Min：最小响应时间，单位为毫秒；
  Max：最大响应时间，单位为毫秒；
  Content Size：所有请求的数据量，单位为字节；
  reqs/sec：每秒钟处理请求的数量，即QPS；

使用fasthttp来请求API压测
  目前号称最好的http库，号称比官方自带的net/http快很多 
  github地址: https://github.com/valyala/fasthttp

  基本代码
    func req(name string,url string )  {
      start := time.Now()
      req:= fasthttp.AcquireRequest()
      defer fasthttp.ReleaseRequest(req)

      req.Header.SetMethod("GET")
      req.SetRequestURI("http://localhost:8080/user/123")

      rsp:=fasthttp.AcquireResponse()
      defer fasthttp.ReleaseResponse(rsp)

      err:=fasthttp.Do(req,rsp)
      if err!=nil{
        boomer.RecordFailure("http", name,0,
          fmt.Sprintf("request err:%s",err.Error()))
        return
      }
      end := time.Since(start)
      if rsp.StatusCode()>=400{
        boomer.RecordFailure("http", name, end.Nanoseconds()/int64(time.Millisecond),
          fmt.Sprintf("status code:%d",rsp.StatusCode))
      } else {
        boomer.RecordSuccess("http", name,
          end.Nanoseconds()/int64(time.Millisecond),int64( rsp.Header.ContentLength()))
      }
    }

Wrk压测
  开源的性能测试工具 wrk， 很类似apache benchmark（ab）同属于性能测试工具，但是比 ab 功能更加强大，并且可以支持lua脚本来创建复杂的测试场景。

  安装
    docker pull williamyeh/wrk

  测试
    docker run --rm  \
      williamyeh/wrk  \
      -t12 -c400  -d5s  --latency http://192.168.29.1:8080/user/123

    使用12个线程并保持400个HTTP连接打开的状态下运行5秒的基准测试

  wrk支持在三个阶段对压测进行个性化修改，分别是 
    1、启动 阶段 ： function setup(thread)   线程已初始化但没启动的时候调用 
    2、结束阶段  function done(summary, latency, requests)
    3、运行阶段
      function init(args)进入运行阶段时，调用一次
      function delay()每次发送request之前调用
      function request()生成请求；每一次请求都会调用该方法
      function response(status, headers, body)在每次收到一个响应时调用
  
  脚本
    根据参数 ，生成一个HTTP rquest  
      function wrk.format(method, path, headers, body)
    
    request = function()
      local  uid = math.random(1, 1000)
      local  path = "/user/".. uid
      return wrk.format("GET", path)
    end

    测试
      docker run --rm  \
        -v `pwd`:/data \
        -w /data \
        williamyeh/wrk  \
        -t12 -c400  -d5s   --latency  http://192.168.29.1:8080  -s user.lua
