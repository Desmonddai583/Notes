使用Go调用Docker API
  docker开放tcp连接
    对于centos7文件在
    /usr/lib/systemd/system/docker.service

    找到这个（注释掉）
    ExecStart=/usr/bin/dockerd

    改成：
    ExecStart=/usr/bin/dockerd -H unix:///var/run/docker.sock -H tcp://0.0.0.0:2345

  重启docker
    systemctl restart docker.service
    systemctl daemon-reload  

  使用docker sdk
    go get github.com/docker/docker/client

  测试
    cli, err := client.NewClient("tcp://39.105.28.235:2345", "v1.35", nil, nil)
    if err!=nil{
      log.Fatal(err)
    }
    images, err := cli.ImageList(context.Background(),types.ImageListOptions{})
    if err!=nil{
      log.Fatal(err)
    }

    config:=&container.Config{
      WorkingDir:"/app",
      Cmd:[]string{"./myserver"},
      Image:"alpine:3.12",
      ExposedPorts: map[nat.Port]struct{}{"80/tcp":Empty{}},
    }
    hostConfig:=&container.HostConfig{
      Binds:[]string{"/home/shenyi/myweb:/app"},
      PortBindings: map[nat.Port][]nat.PortBinding{
        "80/tcp":[]nat.PortBinding{nat.PortBinding{HostPort:"80"}},
      },
    }
    ctx:=context.Background()
    ret,err:=cli.ContainerCreate(ctx,config,
      hostConfig,nil,"myweb",
      )
    if err!=nil{
      log.Fatal(err)
    }
    fmt.Println(ret.ID,"created")
    err=cli.ContainerStart(ctx,ret.ID,types.ContainerStartOptions{})
    if err!=nil{
      log.Fatal(err)
    }

Rancher准备工作
  1、非必须
    docker stop $(docker ps -a -q) //  stop停止所有容器
    docker  rm $(docker ps -a -q) //   remove删除所有容器
  2、关闭防火墙
    systemctl stop firewalld && systemctl disable firewalld
  3、关闭 SELinux
    1）setenforce 0
    2) sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
  4、关闭swap
    swapoff -a

  重启docker
  1、sudo systemctl daemon-reload
  2、sudo systemctl restart docker

启动rancher
  sudo docker run -d --restart=unless-stopped -p 8080:80 -p 8443:443 -v /home/shenyi/rancher:/var/lib/rancher/ rancher/rancher:stable

Rancher 2.4使用k8s-coredns 作为服务发现基础
在同一个命名空间内： 可以通过  service_name 直接解析
不同命名空间内容： service_name. namespace_name

部署nfs服务进行跨主机文件共享
  安装(主机操作)
    1、sudo yum -y install nfs-utils 
    2、配置
      sudo vi /etc/sysconfig/nfs
      加入
      LOCKD_TCPPORT=30001 #TCP锁使用端口
      LOCKD_UDPPORT=30002 #UDP锁使用端口
      MOUNTD_PORT=30003 #挂载使用端口
      STATD_PORT=30004 #状态使用端口
    3、启动/重启服务
      1、sudo systemctl restart rpcbind.service 
      2、sudo systemctl restart nfs-server.service
    4、开机启动：
      1、sudo systemctl enable rpcbind.service
      2、sudo systemctl enable nfs-server.service
    
  编辑共享目录
    编辑/etc/exports
      sudo vi /etc/exports
    写入如下内容
      /home/shenyi/goapi    172.17.70.0/24(rw,async)
    参数说明
      root_squash（默认）：将来访的root用户映射为匿名用户或用户组；
      no_root_squash：来访的root用户保持root帐号权限 ；
      no_all_squash（默认）：访问用户先与本机用户匹配，匹配失败后再映射为匿名用户或用户组；
      all_squash：将来访的所有用户映射为匿名用户或用户组；
      secure（默认）：限制客户端只能从小于1024的tcp/ip端口连接服务器；insecure：允许客户端从大于1024的tcp/ip端口连接服务器；
      anonuid：匿名用户的UID值，通常是nobody或nfsnobody，可以在此处自行设定；
      anongid：匿名用户的GID值；
      no_subtree_check：如果NFS输出的是一个子目录，则无需检查其父目录的权限（可以提高效率） 

  查看挂载
    showmount -e localhost
    会发现没有 于是重启nfs服务  (sudo systemctl restart nfs-server.service)
    接下来 
      请自行创建刚才的文件夹 
 
  另外一台服务器上
    sudo yum -y install nfs-utils  这样就好了，不需要启动nfs服务
    直接执行如下：
      showmount -e 172.17.70.145
    尝试进行挂载  
      mount -t nfs 172.17.70.145:/home/shenyi/goapi   /home/shenyi/goapi
    卸载只需unmount /home/shenyi/goapi

使用Rancher创建PV和PVC
  nfs改动
    sudo vi /etc/exports
    改成这样 
    /home/shenyi/goapi    172.17.70.0/24(rw,async,insecure,no_root_squash)
    然后执行 exportfs -a 重新加载配置

  概念
    Persistent Volume Claim(PVC)和Persistent Volume（PV）
      PV： 定义Volume的类型、挂载目录、远程存储服务器等
      PVC：定义 Pod想要使用的持久化属性，比如存储大小、读写权限等..
    StorageClass： PV的模板，自动为PVC创建PV

集群部署Redis
  首先创建文件夹
    /home/shenyi/redis
        -----n1
            -----conf
                  ------redis.conf
            -----data    (用来存放数据目录)
            -----logs     (用来存放日志)
    
  其中配置文件中
    daemonize no (不以守护进程启动)
    port 6379
    bind 0.0.0.0
    logfile /logs/redis.log   (日志文件)
    dir /data   (数据目录)

  在Nfs服务器上export 文件夹
    sudo vi /etc/exports
    加入如下一行：
    在  /home/shenyi/redis    172.17.70.0/24(rw,async,insecure,no_root_squash)
    然后执行 exportfs -a  
    或(sudo systemctl restart nfs.service)
    重新加载配置

  映射
    n1/conf:/conf
    n1/data:/data
    n1/logs:/logs
    注意：n1 是 子目录  前面不要加 /

  启动命令
    redis-server /conf/redis.conf

  可以使用configmap来挂载redis配置文件

搭建简易私有镜像仓库
  私有镜像管理项目 两种方式
    1、使用一个简单的官方docker registry镜像
    2、使用harbor(如果你需要管理功能)
      Harbor是由VMware公司开源的企业级的Docker Registry管理项目，它包括权限管理(RBAC)、LDAP、日志审核、管理界面、自我注册、镜像复制和中文支持等功能

  docker-compose安装
    1、sudo curl -L https://github.com/docker/compose/releases/download/1.26.2/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
    2、给与可执行权限
      sudo chmod +x /usr/local/bin/docker-compose

  镜像地址
    https://hub.docker.com/_/registry
    在需要的机器上执行
      docker pull registry

  基本运行
    docker run -d --name registry \
      -v /home/shenyi/registry/config.yml:/etc/docker/registry/config.yml \
      -v /home/shenyi/registry/data:/var/lib/registry \
      -p 5000:5000 registry 

  配置文件
    version: 0.1
    log:
    fields:
    service: registry
    storage:
    delete:
      enabled: true
    cache:
      blobdescriptor: inmemory
    filesystem:
      rootdirectory: /var/lib/registry
    http:
    addr: :5000
    headers:
      X-Content-Type-Options: [nosniff]
    health:
    storagedriver:
    enabled: true
    interval: 10s
    threshold: 3

  测试
    找个已经有的镜像，打个tag
      docker tag  redis:5-alpine  172.17.70.145:5000/redis:v1
    传到私有镜像仓库里
      docker push 172.17.70.145:5000/redis:v1

    查看API（https://docs.docker.com/registry/spec/api/#listing-repositories）
      curl http://172.17.70.145:5000/v2/_catalog   (查看列表)
      curl http://172.17.70.145:5000/v2/redis/manifests/v1   (查看redis镜像详情)
      curl http://172.17.70.145:5000/v2/redis/tags/list
      curl -X DELETE http://172.17.70.145:5000/v2/redis/manifests/xxx (xxx代表sha256值)
    垃圾回收：registry garbage-collect /etc/docker/registry/config.yml 

  设置安全
    不出意外会报一个错误http: server gave HTTP response to HTTPS client
    那是因为docker为了安全，需要https 。但是我们可以让其不需要
    要修改的是/etc/docker/daemon.json
    {
        "insecure-registries":["172.17.70.145:5000"]
    }
    然后重载docker 即可systemctl  reload docker

  下载镜像
    docker pull 172.17.70.145:5000/redis:v1

搭建gitlab
  下载镜像
    docker pull gitlab/gitlab-ce
  
  创建专属pv
    sudo vi /etc/exports
    加入一行 
    /home/shenyi/gitlab    172.17.70.0/24(rw,async,insecure,no_root_squash)
    然后执行 sudo exportfs -a 重新加载配置
    /home/shenyi/gitlab 的子目录
      ----config
      ----logs
      ----data

  挂载内容
    /etc/gitlab -> logs
    /var/opt/gitlab -> data
    /var/log/gitlab -> config

    配置负载均衡时 别忘了加:
      nginx.ingress.kubernetes.io/rewrite-target

rancher+gitlab+go创建/提交项目
  生成SSH key并在gitlab上使用public key配置
  测试
    ssh -T git@git.jtthink.com -p 30022    
  项目中执行
    1、git init 
    2、git config --global user.name "你的用户名" 
       git config --global user.email "xxxxxxooo"
  pull
    最终的地址是ssh://git@git.jtthink.com:30022/shenyi/mygo.git
    git pull origin master --allow-unrelated-histories

gitlab-ci
  CI(Continuous integration， 持续集成)
    持续集成强调开发人员提交了新代码之后，立刻进行构建、（单元）测试。根据测试结果，我们可以确定新代码和原有代码能否正确地集成在一起 
  CD(Continuous Delivery， 持续交付)
    是在持续集成的基础上，将集成后的代码部署到更贴近真实运行环境(类生产环境)中。 如果代码没有问题，可以继续部署到生产环境 
  常见CI工具有 gitlab-ci、drone和老牌的jenkins等等

  暂时先不使用k8s
    docker pull gitlab/gitlab-runner
    然后创建一个文件夹 /home/shenyi/gitlab-runner
    docker run -d --name gitlab-runner   \
      -v /home/shenyi/gitlab-runner:/etc/gitlab-runner \
      -v /var/run/docker.sock:/var/run/docker.sock \
      gitlab/gitlab-runner
    接下来执行 
      docker exec -it gitlab-runner  gitlab-runner register
      register时会需要填入相关信息，可在gitlab中repo的设置中查看

  .gitlab-ci.yml
    stages:
      - test
      - build
    job1:
      stage: test
      script:
        - echo "it is test"
    
    job2:
      stage: build
      script:
        - echo "it is build"
    
    参数
      script             由Runner执行的Shell脚本。
      image              使用docker镜像，  image：name
      service            使用docker  services镜像, services：name
      before_script      执行作业前运行的脚本
      after_script       作业完成后运行的脚本
      stages             定义管道中的步骤，依次运行
      stage              定义管道中步骤的作业段
      only    　　        指定作业限制only:refs，only:kubernetes，only:variables，和only:changes
      tags               指定执行作业的runner
      allow_failure      允许job失败
      when               什么时候开始工作，
        on_success       只有当前一个阶段的所有工作都成功时（或者因为它们被标记而被认为是成功的allow_failure）才执行工作 。这是默认值。
        on_failure       仅当前一阶段的至少一个作业失败时才执行作业。
        always           无论先前阶段的工作状态如何，都可以执行工作。
        manual           手动执行作业
        delayed          延迟作业。后面跟start_in,start_in 30minutes(延迟30分钟)，不加单位，默认为秒。最长可延迟1小时。
      environment     作业部署到的环境名称   #暂未搞清
      cache    
        key："$CI_JOB_STAGE-$CI_COMMIT_REF_SLUG" #为每分支，每步骤启用缓存
      artifacts         job成功时附加到作业的文件或目录
      dependencies      此job依赖其他jobz,主要作用于作业优先级
      converage         给定作业代码覆盖率设置　　　　　　 
      retry             在发生故障时，可以自动重试作业的次数。
      parallel　　      应该并行运行多少个作业实例
      trigger          定义下游管道触发器
      include          允许此作业包含外部YAML
      extends          此作业将继承的配置项
      pages            上传作业结果用于gitlab pages
      variables        作业级别定义作业变量

  编译Go程序、打包镜像
    修改下挂载
      docker run -d --name gitlab-runner   \
        -v /home/shenyi/gitlab-runner:/etc/gitlab-runner \
        -v /var/run/docker.sock:/var/run/docker.sock \
        -v /usr/bin/docker:/usr/bin/docker \
        -v /usr/lib64/libltdl.so.7:/usr/lib/x86_64-linux-gnu/libltdl.so.7  \
        gitlab/gitlab-runner
      并在宿主机上执行 ：chmod 666 /var/run/docker.sock

    修改.gitlab-ci.yaml
      stages:
        - test
      job1:
        stage: test
        script:
          - docker build -t mygo:v1  .
        tags:
          - go

    Dockerfile
      FROM golang:1.14.4-alpine3.12
      RUN mkdir /src /app

      ADD . ../src
      ENV GOPROXY="https://goproxy.io"
      RUN cd /src && ls && go build -o ../app/mygo main.go && cd /app && chmod +x mygo && cd /
      RUN rm src -fr
      WORKDIR /app
      ENTRYPOINT  ["/app/mygo"]

    瘦身镜像
      FROM golang:1.14.4-alpine3.12
      RUN mkdir /src /app

      ADD . ../src
      ENV GOPROXY="https://goproxy.io"
      RUN cd /src && ls && go build -o ../app/mygo main.go && cd /app && chmod +x mygo && cd /

      FROM alpine:3.12
      RUN mkdir /app
      COPY --from=0 /app/mygo /app
      ENTRYPOINT ["/app/mygo"]

  加入单元测试
    写了一个函数
      func isAllNumber(str string ) bool  {
        reg:=regexp.MustCompile(`^\d+`)
        return reg.MatchString(str)
      }
      然后写入单元测试文件

    Dockerfile
      FROM golang:1.14.4-alpine3.12
      ADD . /src
      WORKDIR /src
      cmd ["go","test"]
    
    配置文件
      stages:
        - test
        - build
      GoTest:
        stage: test
        script:
          - docker build -f DockerfileTest -t test-mygo:v1 .
          - docker run --rm test-mygo:v1
        after_script:
          - docker rmi test-mygo:v1
        tags:
          - go
      GoBuild:
        stage: build
        script:
          - docker build -t mygo:v1  .
        after_script:
          - docker rmi $(docker images -af "dangling=true" -q)
        tags:
          - go

  发布到私有镜像库
    代码改成http服务
      go get github.com/gin-gonic/gin

    加入配置
      GoDeploy:
        stage: deploy
        script:
          - docker tag  mygo:v1  172.17.70.145:5000/mygo:v1
          - docker push 172.17.70.145:5000/mygo:v1
        after_script:
            - docker rmi 172.17.70.145:5000/mygo:v1
            - docker rmi mygo:v1
        tags:
          - go

  自动更新服务 
    修改runner
      docker run -d --name gitlab-runner   \
        -v /home/shenyi/gitlab-runner:/etc/gitlab-runner \
        -v /var/run/docker.sock:/var/run/docker.sock \
        -v /usr/bin/docker:/usr/bin/docker \
        -v /usr/lib64/libltdl.so.7:/usr/lib/x86_64-linux-gnu/libltdl.so.7  \
        -v /usr/local/bin/kubectl:/usr/local/bin/kubectl \
        -v /home/shenyi/kubectlconfig/config:/kubeconfig \
        -e KUBECONFIG=/kubeconfig \
        gitlab/gitlab-runner

    加入配置
      GoPub:
        stage: publish
        script:
          - kubectl get pod -n myweb| grep mygo | awk '{print $1}' | xargs kubectl delete pod -n myweb
        tags:
          - go

灰度发布
  设置标签
    Nginx –Ingress ，支持配置 标签来实现不同场景下的灰度发布和测试。  
    主要使用如下标签
      nginx.ingress.kubernetes.io/canary   
      nginx.ingress.kubernetes.io/canary-by-header
      nginx.ingress.kubernetes.io/canary-by-header-value
      nginx.ingress.kubernetes.io/canary-weight
      nginx.ingress.kubernetes.io/canary-by-cookie
  
  结合CI/CD
    创建pub.yaml
      创建deployment
        apiVersion: apps/v1
        kind: Deployment
        metadata:
          name: mygo
          namespace: myweb
        spec:
          selector:
            matchLabels:
              app: mgo
          replicas: 1
          template:
            metadata:
              labels:
                app: mgo
            spec:
              containers:
                - name: mygo
                  image: 172.17.70.145:5000/mygo:v1
                  imagePullPolicy: IfNotPresent
                  ports:
                    - containerPort: 80

      创建service
        apiVersion: v1
        kind: Service
        metadata:
          name: mygo-service
          namespace: myweb
        spec:
          selector:
            app: mgo   #这个和前面的app也是对应
          ports:
            - protocol: TCP
              port: 80
              targetPort: 80
          type: ClusterIP    #ClusterIP、NodePort和LoadBalancer

      创建ingress
        apiVersion: extensions/v1beta1
        kind: Ingress
        metadata:
          name: mygolb
          namespace: myweb
          annotations:
            nginx.ingress.kubernetes.io/canary: "true"
            nginx.ingress.kubernetes.io/canary-by-header: "version"
            nginx.ingress.kubernetes.io/canary-by-header-value: "v2"
        spec:
          rules:
            - host: api2.jtthink.com
              http:
                paths:
                  - path: /
                    backend:
                      serviceName: mygo-service
                      servicePort: 80

    修改配置
      GoPub:
        stage: publish
        script:
          - kubectl apply -f pub.yaml
        tags:
          - go

部署etcd
  配置nfs-server
    1、首先创建一文件夹 : /home/shenyi/etcdconf
    2、cd进入后，再创建 etcd1目录

    目录结构是
      /home/shenyi/etcdconf
        ---etcd1
        ---conf
        ---data

    sudo vi /etc/exports
    加入配置
    然后执行 sudo exportfs -a 重新加载配置
    查看 
      showmount -e 172.17.70.145

  单机配置文件
    使用cm配置即可
      name: etcd1
      data_dir: /etcd/data
      listen-client-urls: http://0.0.0.0:2379

    启动命令 是  etcd --config-file /etcd/conf/etcd.yaml

  golang测试连接etcd
    go get go.etcd.io/etcd/clientv3
    如果有版本冲突，可以降低grpc的库,修改go.mod
      replace google.golang.org/grpc => google.golang.org/grpc v1.26.0 

    测试连接
      export ETCDCTL_API=3  切换为API3
      etcdctl get /service/test 

  nginx-ingress反代etcd
    Ingress Controller监听两个configmap(tcp和udp)，可以设置反代的TCP暴露的端口。当修改并且发生变化后，Ingress controller会去更改Nginx的配置，增加对应的监听
    格式
      端口:<namespace/service_name>:<service port>
      于是我们加入 一个配置：
      key是32379 对应的值是 myweb/etcd1:2379

  创建etcd集群
    基本配置说明
      listen-client-urls：etcd监听url和端口 
      advertise-client-urls：etcdctl或curl等客户端工具交互时用的url地址（一般和上面的一样）
      listen-peer-urls： 节点通信地址，  如：Leader 选举、Message消息传输、快照等。
      initial-advertise-peer-urls：同上
      initial-cluster-token：集群唯一标识
      initial-cluster：集群中所有的initial-advertise-peer-urls的合集。
      initial-cluster-state：新建集群的标识。

    配置
      name: etcd1
      data-dir: /etcd/data
      listen-client-urls: http://0.0.0.0:2379
      advertise-client-urls: http://0.0.0.0:2379
      listen-peer-urls: http://0.0.0.0:2380
      initial-advertise-peer-urls: http://etcd1:2380
      initial-cluster-token: 'etcd-cluster'
      initial-cluster: etcd1=http://etcd1:2380,etcd2=http://etcd2:2380,etcd3=http://etcd3:2380
      initial-cluster-state: 'new'
    
    创建时别忘了加上环境变量： ETCDCTL_API  =3
    启动命令是 etcd --config-file /etcd/conf/etcd.yaml

    基本情况查询  
      查看节点列表
        etcdctl -w table member list

      查看单节点信息
        etcdctl -w table  endpoint status

      查看全部
        etcdctl -w table --endpoints=etcd1:2379,etcd2:2379,etcd3:2379  endpoint status

sidecar
  SideCar是在Pod中延伸或增强主容器的容器。主容器和 Sidecar 共享一个 Pod，可以共享相同的网络空间和存储空间

  主容器和sidecar共享存储
    https://kubernetes.io/zh/docs/concepts/storage/volumes/#emptydir

    在主容器上写入（和image同级）
      volumeMounts:
        - mountPath: /var/log/nginx
          name: nginx-log

    SideCar中也写入
      volumeMounts:
        - mountPath: /app
          name: vol4
        - mountPath: /var/log/nginx
          name: nginx-log

    最后加入
      volumes:
        - emptyDir: {}
          name: nginx-log
        - name: vol4
          persistentVolumeClaim:
            claimName: gopvc

  sidecar的基本使用场景-日志收集
    filebeat
      用于转发和集中日志数据的轻量级传送工具。Filebeat监视您指定的日志文件或位置，收集日志事件，并将它们转发到Elasticsearch或 数据库中
      配置文档指引:
        https://www.elastic.co/guide/en/beats/filebeat/current/filebeat-input-log.html
      它属于beats家族成员之一
        看github地址https://github.com/elastic/beats
        包含了Packetbeat收集网络流量数据、Metricbeat收集系统、进程的CPU、内存使用情况等数据、Filebeat收集文件数据  等等

      https://www.elastic.co/guide/en/beats/filebeat/current/running-on-docker.html
    
    收集nginx日志(输出到控制台)
      基本的配置--input 
        https://www.elastic.co/guide/en/beats/filebeat/current/configuration-filebeat-options.html
        
        filebeat.inputs:
        - type: log
          paths:
            - /var/log/nginx/access.log

        放到configmap里面

      基本的配置--output
        https://www.elastic.co/guide/en/beats/filebeat/current/console-output.html
        
        output.console:
          pretty: true
        
        放到configmap里面
      
      filebeat.inputs:
      - type: log
        enabled: true
        paths:
          - /var/log/nginx/access.log
      output.console:
        pretty: true
      setup.template.enabled: false
      scan_frequency: 2s

部署ElasticSearch
  安装文档：https://www.elastic.co/guide/en/elasticsearch/reference/7.4/docker.html

  新开一个命名空间 叫做 elk
  docker run --rm --name testes -it  docker.elastic.co/elasticsearch/elasticsearch:7.4.2 sh
  进去后可以看到 ，es的配置文件主要在：
    /usr/share/elasticsearch/config
  拷贝下来
    cd /usr/share/elasticsearch/config && cat elasticsearch.yml
    mkdir myes
    然后创建一个文件夹叫做 es1 , 拷贝到这个地方
    docker cp testes:/usr/share/elasticsearch/config .

  基本的配置
    cluster.name: myes
    network.host: 0.0.0.0
    http.port: 9200
    node.name: "es1"
    cluster.initial_master_nodes: ["es1"]
  
  在各个节点上执行：
    sudo sysctl -w vm.max_map_count=262144 （一个进程可以拥有的VMA(虚拟内存区域)的数量）

  部署 ElasticSearch集群
    增加一些配置 ：
      transport.tcp.port: 9300
      discovery.zen.ping.unicast.hosts: ["es1", "es2"]

    再来一个
      cluster.name: myes
      network.host: 0.0.0.0
      http.port: 9200
      node.name: "es2"
      cluster.initial_master_nodes: ["es1"]
      transport.tcp.port: 9300
      discovery.zen.ping.unicast.hosts: ["es1", "es2"]

      使用的镜像依然是：docker.elastic.co/elasticsearch/elasticsearch:7.4.2
      挂载文件依然是elasticsearch.yml 挂载到/usr/share/elasticsearch/config/elasticsearch.yml

  部署Kibana、连接ES集群
    docker pull elastic/kibana:7.4.2

    docker run --rm --name testkb -it  elastic/kibana:7.4.2 sh
    kibana的配置文件在 /usr/share/kibana/config这个目录， 叫做kibana.yml

    创建配置文件
      server.port: 5601   
      server.host: "0.0.0.0"
      
      #ES请求的服务URL
      elasticsearch.hosts: ["http://es1:9200","http://es2:9200"]
      #无证书
      elasticsearch.ssl.verificationMode: none
      xpack.security.enabled: false   //不使用安全验证
      
    加入Basic Auth身份验证
      加入标签
        nginx.ingress.kubernetes.io/auth-type: basic
        nginx.ingress.kubernetes.io/auth-secret: kb-auth
        文档在此：https://kubernetes.github.io/ingress-nginx/user-guide/nginx-configuration/annotations/#authentication

      安装工具
        yum -y install httpd-tools
        Apache的Web服务器内置的工具,用于创建和更新储存用户名和用户基本认证的密码文件

        创建一个密码文件  
        htpasswd -c auth shenyi
        这时产生了一个 auth文件

        再添加一个  用户(此时不用-c参数)
        htpasswd  auth lisi

      创建secret
        kubectl -n elk create secret generic kb-auth  --from-file=auth

  安装中文分词插件 
    sudo vi /etc/exports

    加入一行
    /home/shenyi/es 172.17.70.0/24(rw,async,insecure,no_root_squash)

    修改后 执行
    exportfs -r 或者 systemctl reload nfs-server

    确认: showmount -e 172.17.70.145

    使用 es7.4.2 ，默认容器的插件路径在： /usr/share/elasticsearch/plugins , 把它挂载到刚才创建的目录中

    插件地址 https://github.com/medcl/elasticsearch-analysis-ik
    下载地址：https://github.com/medcl/elasticsearch-analysis-ik/releases/tag/v7.4.2
    解压后（文件夹名设置成analysis-ik ，然后通通拷贝到plugins里面）
    先拷贝到tmp目录下，然后 sudo 拷贝过来
      cp ~/tmp/analysis-ik .  -r
    注意：分词器必须和ES版本一致

    测试
      POST  _analyze
      {
        "analyzer": "ik_smart",
        "text" : "程序教程java"
      }
  
  使用SQL查询ElasticSearch
    创建一个索引
      PUT /books
      {
        "mappings": {
          "properties": {
            "BookID":    { "type": "integer" },
            "BookName":    { "type": "text","analyzer": "ik_max_word","search_analyzer": "ik_smart","fields":{ "keyword":{"type":"keyword","ignore_above":256}}},  
            "BookPrice":   { "type": "float"},  
            "BookAuthor":   { "type": "keyword"}
          }
        }
      }
    
    批量插入一些数据
      POST _bulk
      { "index" : { "_index" : "books", "_id" : "101" } }
      {"BookID":101,"BookName":"C语言程序设计","BookPrice":19,"BookAuthor":"老蒋"}
      { "index" : { "_index" : "books", "_id" : "102" } }
      {"BookID":102,"BookName":"PHP高级编程","BookPrice":29,"BookAuthor":"老李"}
      { "index" : { "_index" : "books", "_id" : "103" } }
      {"BookID":103,"BookName":"java编程从入门到精通","BookPrice":39,"BookAuthor":"老王"}
      { "index" : { "_index" : "books", "_id" : "104" } }
      {"BookID":104,"BookName":"无需流汗和吃苦3天成为java大神","BookPrice":15.5,"BookAuthor":"老张"}

    SQL访问
      文档
        https://www.elastic.co/guide/en/elasticsearch/reference/current/sql-getting-started.html
        https://www.elastic.co/guide/en/elasticsearch/reference/current/sql-syntax-select.html

      POST /_sql
      {  
        "query": "SELECT * FROM books WHERE BookAuthor = '老王'"
      }

      加入?format=txt 参数可以显示 table格式

    翻译
      POST /_sql/translate
      {  
        "query": "SELECT * FROM books WHERE BookAuthor = '老王'"
      }
    
    match
      文档:
        https://www.elastic.co/guide/en/elasticsearch/reference/current/sql-functions-search.html

      "query": "SELECT BookName,BookID FROM books WHERE match(BookName,'我从小就喜欢编程')  "
      "query": "SELECT BookName,BookID FROM books WHERE match('BookName','我从小就喜欢java编程') order by SCORE() desc "

  配置负载均衡&Go调用
    安装客户端库 go get github.com/olivere/elastic/v7

    func getClient() *elastic.Client  {
      client, err := elastic.NewSimpleClient(
        elastic.SetSniff(false),
        elastic.SetURL("http://es.jtthink.com/es1/","http://es.jtthink.com/es2/" ),
      )
      if err != nil {
        panic(err)
      }
      return  client
    }
  
    辅助函数
      type Books struct{
        BookID int
        BookName string
        BookPrice1 float64
        BookAuthor string
      }
      func MapToBooks(rsp *elastic.SearchResult) []*Books  {
        ret:=[]*Books{}
        var t *Books
        for _,item:=range rsp.Each(reflect.TypeOf(t)){
          ret=append(ret,item.(*Books))
        }
        return ret
      }

    matchQuery:=elastic.NewMatchQuery("BookName","编程")
    ret,err:=getClient().Search().Index("books").Query(matchQuery).Do(context.Background())
    if err!=nil{
      log.Fatal(err)
    }
    books:=MapToBooks(ret)