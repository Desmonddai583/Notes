指令
  kubectl get pods -n myweb 查看指定 namespace下的 pods列表  
  kubectl get deployment  -n myweb 查看deployment
  kubectl delete deployment myngx -n myweb 删除deployment

kubectl
  kubectl是Kubernetes集群的命令行工具，通过kubectl能够对集群本身进行管理，并能够在集群上进行容器化应用的安装部署
  https://github.com/kubernetes/kubernetes/blob/master/CHANGELOG/CHANGELOG-1.18.md
  把解压出来的kubectl移动到 /usr/local/bin 里面
  chmod +x kubectl
  kubectl version  查看版本 

  配置
    1、目录：/home/desmond/kubectl
    2、配置文件 名叫做config
    3、然后编辑 ~/.bash_profile  把上述文件加入到环境变量中
      KUBECONFIG=/home/desmond/kubectl/config
      然后执行  source ~/.bash_profile

  测试
    kubectl cluster-info

kubelet
  负责master和节点（node）之间的通信、交互和数据上报到master的apiserver

  整体来讲 的职责是
  1、Node管理 
  2、pod管理 
  3、容器健康检查
  4、容器监控
  5、资源清理
  6、和容器运行时交互(docker 、rkt、Virtlet等等)

  一般情况下kubelet会暴露 10250端口 用于和apiserver 交互
  常用的查询API 
    GET  
    /pods
    /stats/summary
    /metrics
    /healthz
  
  访问方式
    docker exec -it kubelet curl -k https://localhost:10250/healthz  --header "Authorization: Bearer kubeconfig-user-mtxnk.c-gfv2c:h86t2zzpjcq8lksd82l24l6ld7pkdwsh4264thvbfxldntkmdmf2c8" 

kube-proxy 
  kube-proxy 运行在每个Node 上，负责Pod网络代理,  维护网络规则和四层负载均衡工作  
  默认模式: UserSpace(已废弃)、iptables、ipvs 

kube-controller-manager
  在master中
  kube-controller-manager负责节点管理、pod复制和endpoint创建.
  监控集群中各种资源的状态使之和定义的状态保持一致
  如:
    节点控制器（Node Controller）: 负责在节点出现故障时进行通知和响应。
    副本控制器（Replication Controller）: 负责为系统中的每个副本控制器对象维护正确数量的 Pod。(现在是Deployment Controller+Replication Set)

主机调度:nodeName和nodeSelector
  nodeName方式
    spec:
      nodeName: node1
  
  nodeSelector
    根据标签
      kubectl get node --show-labels
    添加标签
      kubectl label nodes <node-name> <label-key>=<label-value> 
      kubectl label nodes dsjs  name=a1
      kubectl label nodes dsjs2 name=a2
    删除标签
      kubectl label nodes <node-name> <label-key>
      kubectl label nodes dsjs name
    修改标签
      kubectl label nodes <node-name> <label-key>=<label-value> --overwrite

    配置
      spec:
        nodeSelector:
          name: a2

Helm3
  helm是 k8s的包管理器
  helm 拥有一个命令行工具，用于本地开发及管理chart
  1、chart ：Helm的打包格式叫做chart， 就是一系列文件, 它描述了一组相关的 k8s 集群资源
  2、Repoistory ：Helm chart 的仓库，Helm 客户端获取存储库中 chart 的索引文件和压缩包 
  安装方式 https://github.com/helm/helm

  仓库
    微软的chart仓库
      http://mirror.azure.cn/kubernetes/charts/
    各种charts查询  Kubeapps Hub
      https://hub.kubeapps.com/charts/incubator
    添加仓库
      1、helm repo add stable http://mirror.azure.cn/kubernetes/charts/
      2、helm repo update
    搜索
      helm search repo stable/mysql
      helm install  mydb  stable/mysql
  
  创建项目命令
    helm create mygin  
    helm install my mygin --dry-run --debug  测试
    helm template my mygin 渲染

    渲染+安装
      helm install my  mygin -n myweb
      (helm install [NAME] [CHART] [flags])

  阿里云私有镜像库(云效)
    https://repomanage.rdc.aliyun.com/my/helm-repos/namespaces

    提交
      helm push mygin-0.1.0.tgz $NAMESPACE
      提交完成后 刷新repo
        helm repo update
        helm search repo $NAMESPACE/mygin
      安装测试
        helm install my $NAMESPACE/mygin -n myweb

Ingress
  Ingress是请求进入集群内部的规则合集,是k8s1.1之后的一个资源对象
  用来实现
    1. 提供外部可访问的URL
    2. 七层负载均衡
    3. SSL等
  
  Ingress-controller  
    通过负载均衡器来实现Ingress
    以nginx-ingress为例 https://github.com/kubernetes/ingress-nginx
      1. 与k8s api交互,动态获取Ingress规则变化
      2. 根据规则生成Nginx配置,写入运行nginx服务的pod里
      3. 控制器获取配置,生成nginx.conf文件
      4. 变化后reload
    出了nginx之外还有traefik，kong等
  
  helm安装nginx-ingress
    helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
    helm install my-nginx ingress-nginx/ingress-nginx 

    墙内网络会报错(镜像无法pull),解决方法
      找一个可以pull的
        https://hub.docker.com/r/giantswarm/ingress-nginx-controller/tags
        docker pull giantswarm/ingress-nginx-controller:v0.40.2
      改tag
        docker tag giantswarm/ingress-nginx-controller:v0.40.2   k8s.gcr.io/ingress-nginx/controller:v0.40.2
      删之前的tag 
        docker rmi giantswarm/ingress-nginx-controller:v0.40.2
      下载chart到本地
        helm fetch ingress-nginx/ingress-nginx
        修改部分内容后再次安装(注释掉digest:sha256,否则会验证sha值而导致不通过)
        helm install my-nginx ingress-nginx  -n my-nginx-ingress
      更新用的是如下命令
        helm upgrade my-nginx ingress-nginx    -n my-nginx-ingress
    
    DaemonSet
      DaemonSet用于在每个Kubernetes节点中将守护进程的副本作为后台进程运行， 每个节点部署一个Pod，当节点加入到Kubernetes集群中，Pod会被自动调度到该节点上运行,移出时则删掉
      作为nginx-ingress 需要使用这种方式
      修改value.yml
        controller.kind=DaemonSet
      
        hostNetwork设置为true
        pod中服务可以使用宿主机的网络接口，宿主主机所在的局域网上所有网络接口都可以访问到该应用程序
          controller.hostNetwork=true  
          controller.daemonset.hostPorts.http=80 
          controller.daemonset.hostPorts.https=443
        
        controller.service.type 设置为NodePort
        然后设置对应的接口

        controller.admissionWebhooks.enable 设置为false
      更新
        helm upgrade my-nginx ingress-nginx    -n my-nginx-ingress
  
  发布一个负载均衡服务(nginx-ingress)
    https://kubernetes.github.io/ingress-nginx/user-guide/basic-usage/

    apiVersion: networking.k8s.io/v1beta1
    kind: Ingress
    metadata:
      name: ingress-myserviceb
      annotations:
        # use the shared ingress-nginx
        kubernetes.io/ingress.class: "nginx"
    spec:
      rules:
      - host: myserviceb.foo.org
        http:
          paths:
          - path: /
            backend:
              serviceName: xxxxoo
              servicePort: 80

    路径重写
      nginx.ingress.kubernetes.io/rewrite-target: /$2
      ...
      paths:
        - path: /v1(\/?)(.*)

  设置Tcp反代(nginx-ingress
    修改Values.yaml并更新
      tcp: {
        32379: "myweb/etcd1:2379"
      }
    
      helm upgrade my-nginx ingress-nginx    -n my-nginx-ingress
