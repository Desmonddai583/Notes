kubeadm安装
  https://kubernetes.io/zh/docs/setup/production-environment/tools/kubeadm/install-kubeadm/

  1. 
    sudo cat <<EOF > /etc/yum.repos.d/kubernetes.repo
    [kubernetes]
    name=Kubernetes
    baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64/
    enabled=1
    gpgcheck=1
    repo_gpgcheck=1
    gpgkey=https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg
            https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
    EOF

    yum makecache
    注意：切换到root （su - root）把上述执行。然后再切回普通用户，各个主机都要执
  2. 
    sudo yum -y install kubelet-1.20.2  kubeadm-1.20.2  kubectl-1.20.2
    执行 rpm -aq kubelet kubectl kubeadm   看下列表，如果OK就是装好了
    sudo systemctl enable kubelet 把kubelet设置为开机启动

初始化集群
  主要有三个：Kubeadm init、kubeadm join、kubeadm token
    kubeadm init：集群的快速初始化，部署Master节点的各个组件  
    kubeadm join 节点加入到指定集群中
    kubeadm token   管理用于加入集群时使用的认证令牌 (如list，create)
    kubeadm reset  重置集群，如删除 构建文件以回到初始状态 

  每台机器上都要执行 systemctl enable docker.service
  使用systemd作为docker的cgroup driver
    sudo vi  /etc/docker/daemon.json 
    加入
      {
        "exec-opts": ["native.cgroupdriver=systemd"]
      }

  重启docker
    systemctl daemon-reload  && systemctl restart docker
    确保执行这句命令docker info | grep Cgroup
    出来的值是 systemd

  关闭swap
    1.暂时关闭SWAP，重启后恢复
      swapoff   -a
    2. 永久关闭SWAP
      sudo vi /etc/fstab

      # swap was on /dev/sda11 during installation
      #UUID=0xxxxxxxxxxxxxx4f69 none  swap    sw      0       0
      注释掉SWAP分区项 

  master
    sudo kubeadm init --kubernetes-version=v1.18.6  --image-repository registry.aliyuncs.com/google_containers

  sudo kubeadm token list  可以查看token 列表 
  sudo kubeadm token create --print-join-command 重新生成token (默认24小时有效期)

  其他节点加入
    sudo kubeadm join 192.168.0.53:6443 --token yd38ha.1u9xsqsleyw7gjuc \
      --discovery-token-ca-cert-hash sha256:2ef5f37cc530644ba1b6a5d99150af309e9c5d6a16933323ee18a7732811f3c1
  
  安装网络组件（flannel）
    CNI（Container Network Interface）
      容器网络接口，为了让用户在容器创建或销毁时都能够更容易地配置容器网络。
      常用的组件有
        Flannel(最基本的网络组件)、Calico(支持网络策略)、Canal（前两者的合体）、Weave（同样支持策略机制，还支持加密）

    flannel https://github.com/coreos/flannel

    对于centos7 先执行 sudo sysctl net.bridge.bridge-nf-call-iptables=1
    在主机上执行
      kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
    验证
      kubectl get pods --all-namespaces

    可能出现如下错误 
      failed to acquire lease: node "jtthink1" pod cidr not assigned
      通过执行kubectl --namespace kube-system logs kube-flannel-ds-2hpnq 可查看到  

      解决办法
        sudo vi /etc/kubernetes/manifests/kube-controller-manager.yaml

        在command节点 加入 
        - --allocate-node-cidrs=true
        - --cluster-cidr=10.244.0.0/16

        然后执行 systemctl restart kubelet

  设置节点角色
    kubectl label node jtthink2 node-role.kubernetes.io/node=node

kubernetes dashboard
  https://github.com/kubernetes/dashboard
  官方提供的web管理界面,通过dashboard可以很方便地查看集群的各种资源.以及修改资源编排文件,对集群进行扩容操作,查看日志等
  
  kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.4/aio/deploy/recommended.yaml
  执行完后验证下 kubectl get pods --all-namespaces

  访问UI
    kubectl proxy
      kubectl proxy为访问k8s  apiserver的REST api建立反代，提供统一入口进行访问控制、监控、管理，在代理中管理后端，在代理中进行认证等。
      kubectl proxy --address=0.0.0.0 --port=9090  --accept-hosts='^*$'
      注意：云服务器的话 别忘了 9090 要开放 安全组访问

    直接访问k8s api
      http://121.36.252.154:9090/api/v1/namespaces/kube-system/services

    进入界面
      http://121.36.252.154:9090/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy

    创建对应的ServiceCount
      文档 https://github.com/kubernetes/dashboard/blob/master/docs/user/access-control/creating-sample-user.md

      创建一个文件夹  譬如叫做/home/shenyi/dashboard
      创建2个文件 
        第一个db_account.yaml
          apiVersion: v1
          kind: ServiceAccount
          metadata:
            name: admin-user
            namespace: kubernetes-dashboard
        第二个db_role.yaml
          apiVersion: rbac.authorization.k8s.io/v1
          kind: ClusterRoleBinding
          metadata:
            name: admin-user
          roleRef:
            apiGroup: rbac.authorization.k8s.io
            kind: ClusterRole
            name: cluster-admin
          subjects:
          - kind: ServiceAccount
            name: admin-user
            namespace: kubernetes-dashboard
      
      在/home/shenyi/dashboard下执行 kubectl apply -f . 
      再执行 kubectl -n kubernetes-dashboard describe secret $(kubectl -n kubernetes-dashboard get secret | grep admin-user | awk '{print $1}') 会看到token

      这一步还是不能登陆，因为默认只能localhost或127 能登陆
      简单的解决方案是  直接暴露NodePort访问
      创建文件  db_svc.yaml
        kind: Service
        apiVersion: v1
        metadata:
          labels:
            k8s-app: kubernetes-dashboard
          name: kubernetes-dashboard
          namespace: kubernetes-dashboard
        spec:
          ports:
            - port: 443
              targetPort: 8443
              nodePort: 30043
          selector:
            k8s-app: kubernetes-dashboard
          type: NodePort
      执行 kubectl apply -f .   

部署rancher作为管理系统（导入）
  下载镜像 别忘了 8080 和 8443 安全组开放
    sudo docker run -d --privileged --restart=unless-stopped -p 8080:80 -p 8443:443 -v /home/shenyi/rancher:/var/lib/rancher/ rancher/rancher:stable

  kubectl create clusterrolebinding cluster-admin-binding --clusterrole cluster-admin --user kubernetes-admin(这个用户名要去配置文件找)

  curl --insecure -sfL https://192.168.0.106:8443/v3/import/pclwnv429cf4fznp74vfrblsr9w9f4fdvv6gckmtzh6k4tslls66g5.yaml | kubectl apply -f -

  一开始可能出现controller-manager和scheduler不健康的错误
  kubectl get cs  --查看集群监控状况  
  修改 (在master上)
    sudo vi /etc/kubernetes/manifests/kube-scheduler.yaml
    sudo vi /etc/kubernetes/manifests/kube-controller-manager.yaml
    把 --port=0  删掉
    然后systemctl restart kubelet

安装Helm、nginx-ingress
  https://github.com/helm/helm/releases/tag/v3.4.0

  安装nginx-ingress
    1、helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
    2、一定要先随便装下
      helm install my-nginx ingress-nginx/ingress-nginx 

      然后肯定会报错，然后 两条命令 
      1、kubectl logs pod名称
      2、kubectl describe pod 你的pod名称  （这里会看到具体的错误）

      k8s.gcr.io/ingress-nginx/controller:v0.41.0  这个镜像无法下载 墙内

      于是执行 
        docker pull giantswarm/ingress-nginx-controller:v0.41.0
        docker tag giantswarm/ingress-nginx-controller:v0.41.0  k8s.gcr.io/ingress-nginx/controller:v0.41.0  改tag
        docker rmi giantswarm/ingress-nginx-controller:v0.41.0 删之前的tag 
      
        注意：各个节点都要执行
        然后删掉刚才的安装  helm delete my-nginx ，然后再继续其他内容

授权和认证机制
  UserCount 
    也就是集群外部访问时使用的用户。最常见的就是kubectl命令就是作为kubernetes-admin用户来执行，k8s本身不记录这些账号
    
    默认认证方式：客户端证书   
      创建客户端证书
        装openssl (没装执行 sudo yum install openssl  openssl-devel)

        1、创建一个文件夹叫做 ua/shenyi
        2、cd 到 ua/shenyi目录下
        3、执行
        1)openssl genrsa -out client.key 2048    (这一步是生成客户端私钥)
        2)openssl req -new -key client.key -out client.csr -subj "/CN=shenyi"
          (根据私钥生成csr， /CN指定了用户名shenyi)
        4、sudo openssl x509 -req -in client.csr -CA /etc/kubernetes/pki/ca.crt -CAkey /etc/kubernetes/pki/ca.key -CAcreateserial -out client.crt -days 365
          (根据k8s的CA证书生成我们用户的客户端证书)

      使用证书初步请求API、设置上下文
        1、kubectl get endpoints  查看下endpoint
        2、curl --cert ./client.crt --key ./client.key --cacert /etc/kubernetes/pki/ca.crt -s https://192.168.0.53:6443/api
        其中 可以用 --insecure 代替 --cacert /etc/kubernetes/pki/ca.crt 从而忽略服务端证书验证

        证书反解
          如果你忘了证书设置的CN(Common name)是啥 可以用下面的命令
          openssl x509 -noout -subject -in client.crt

        client.crt加入到~/.kube/config，执行kubectl命令时切换成我们的用户(虽然现在其实没啥权限)
        kubectl config --kubeconfig=/home/shenyi/.kube/config set-credentials shenyi  --client-certificate=/home/shenyi/ua/shenyi/client.crt --client-key=/home/shenyi/ua/shenyi/client.key
        这一步把用户设置进去了

        创建一个context(上下文)
        kubectl config --kubeconfig=/home/shenyi/.kube/config set-context user_context --cluster=kubernetes  --user=shenyi
        指定当前上下文是：
        kubectl config --kubeconfig=/home/shenyi/.kube/config use-context user_context

    Role和RoleBinding
      Role (角色)
        它可以包含一堆权限。用于授予对单个命名空间的资源访问
      RoleBinding 
        顾名思义，将用户和角色进行绑定
      kubectl get role --all-namespaces

      创建一个文件叫做：mypod_role.yaml
        kind: Role
        apiVersion: rbac.authorization.k8s.io/v1
        metadata:
          namespace: default
          name: mypod
        rules:
        - apiGroups: ["*"]
          resources: ["pods"]
          verbs: ["get", "watch", "list"]

      kubectl apply -f mypod_role.yaml
      kubectl get role -n default  查看下
      kubectl delete role mypod   (不加-n  默认就是default)

      关于资源
        kubectl api-resources -o wide
        譬如role有 对应的操作如下
          create  delete  deletecollection   get     list    patch     update   watch
          创建 	   删除       批量删除          获取    列表     合并变更    更新     监听

      绑定
        第一种方式： 命令行 
          kubectl create rolebinding mypodbinding  -n default  --role mypod --user shenyi
        第二种方式
          创建一个文件 譬如叫做mypod_rolebinding.yaml
            apiVersion: rbac.authorization.k8s.io/v1
            kind: RoleBinding
            metadata:
              creationTimestamp: null
              name: mypodrolebinding
            roleRef:
              apiGroup: rbac.authorization.k8s.io
              kind: Role
              name: mypod
            subjects:
            - apiGroup: rbac.authorization.k8s.io
              kind: User
              name: shenyi

    CluterRole和RoleBinding
      可以管理集群中多个 namespace,就需要使用到clusterrole
      绑定既可以使用RoleBinding，也可以使用ClusterRoleBinding  (两者效果不同)

      kind: ClusterRole
      apiVersion: rbac.authorization.k8s.io/v1
      metadata:
        name: mypod-cluster
      rules:
      - apiGroups: ["*"]
        resources: ["pods"]
        verbs: ["get", "watch", "list"]
    
      apiVersion: rbac.authorization.k8s.io/v1
      kind: RoleBinding
      metadata:
        name: mypodrolebinding-cluster
        namespace: kube-system
      roleRef:
        apiGroup: rbac.authorization.k8s.io
        kind: ClusterRole
        name: mypod-cluster
      subjects:
      - apiGroup: rbac.authorization.k8s.io
        kind: User
        name: shenyi

      ClusterRoleBinding
        删除命令
          1、 kubectl delete rolebinding mypodrolebinding-cluster -n kube-system
          2、 kubectl delete rolebinding mypodrolebinding
          3、kubectl delete role mypod

        apiVersion: rbac.authorization.k8s.io/v1
        kind: ClusterRoleBinding
        metadata:
          name: mypod-clusterrolebinding
        roleRef:
          apiGroup: rbac.authorization.k8s.io
          kind: ClusterRole
          name: mypod-cluster
        subjects:
        - apiGroup: rbac.authorization.k8s.io
          kind: User
          name: shenyi
    
    配置使用token的方式请求API
      curl https://192.168.0.53:6443   这是不可以访问的
      接下来我们设置一个 token (现在是普通用户)
      
      1、用这个命令生成token 
        head -c 16 /dev/urandom | od -An -t x | tr -d ' ' 
        kubectl config set-credentials shenyi --token=4e2f6f4250a43ce94426b6264dad2609

      curl -H "Authorization: Bearer 4e2f6f4250a43ce94426b6264dad2609" https://192.168.0.53:6443/api/v1/namespaces/default/pods --insecure
      默认情况下还是没用的

      修改api-server的启动参数
        首先创建 
          sudo vi /etc/kubernetes/pki/token_auth 
        塞入如下内容
          4e2f6f4250a43ce94426b6264dad2609,shenyi,1001
        修改api-server启动参数
          sudo vi /etc/kubernetes/manifests/kube-apiserver.yaml
          加入  --token-auth-file=/etc/kubernetes/pki/token_auth

  ServiceAccount
    kubectl get sa -n xxxx  (不写-n 就是默认default) 查看
    kubectl create serviceaccount mysa  创建
    每个namespace都会有一个默认的 default账号，且sa局限在自己所属的namespace中。而UserAccount是可以跨ns的

    kubectl describe sa mysa 
    k8s会在secrets 里面保存一个token
    通过kubectl describe secret mysa-token-sk67q

    第二种创建方式
      kubectl  create  serviceaccount  mysa  -o  yaml  --dry-run=client 
      kubectl  create  serviceaccount  mysa  -o  yaml  --dry-run=client > mysa.yaml

    绑定角色
      kubectl create clusterrolebinding mysa-crb --clusterrole=mypod-cluster --serviceaccount=default:mysa

    外部访问api
      分解命令
      1、kubectl get sa  mysa
      2、 kubectl get sa  mysa -o json
      3、kubectl get sa  mysa -o json | jq  '.secrets[0].name'
      4、kubectl get sa  mysa -o json | jq -Mr '.secrets[0].name'
      假设得到的值是mysa-token-6tggr
      5、kubectl get secret  mysa-token-6tggr
      6、kubectl get secret  mysa-token-6tggr -o json | jq -Mr '.data.token'
      7、 kubectl get secret  mysa-token-6tggr -o json | jq -Mr '.data.token' | base64 -d
      连起来
      kubectl get secret  $(kubectl get sa  mysa -o json | jq -Mr '.secrets[0].name') -o json | jq -Mr '.data.token' | base64 -d
      设置成一个变量
      mysatoken=$(kubectl get secret  $(kubectl get sa  mysa -o json | jq -Mr '.secrets[0].name') -o json | jq -Mr '.data.token' | base64 -d)
      请求
      curl -H "Authorization: Bearer $mysatoken" --insecure  https://192.168.0.53:6443/api/v1/namespaces/default/pods 

    在POD里访问k8s API
      token的方式
        apiVersion: apps/v1
        kind: Deployment
        metadata:
          name: myngx
        spec:
          selector:
            matchLabels:
              app: nginx
          replicas: 1
          template:
            metadata:
              labels:
                app: nginx
            spec:
              containers:
                - name: nginxtest
                  image: nginx:1.18-alpine
                  imagePullPolicy: IfNotPresent
                  ports:
                    - containerPort: 80

        kubectl get pod  可以看到pod列表 ，然后我们 进入 该容器
        kubectl exec -it  myngx-58bddf9b8d-qmdq7 -- sh
        echo $KUBERNETES_SERVICE_HOST   
        echo $KUBERNETES_PORT_443_TCP_PORT
        于是 
        echo $KUBERNETES_SERVICE_HOST:$KUBERNETES_PORT_443_TCP_PORT
        保存到环境变量中
        1、TOKEN=`cat /var/run/secrets/kubernetes.io/serviceaccount/token`
        2、APISERVER="https://$KUBERNETES_SERVICE_HOST:$KUBERNETES_PORT_443_TCP_PORT"
        请求 curl --header "Authorization: Bearer $TOKEN" --insecure -s $APISERVER/api

        但是 curl --header "Authorization: Bearer $TOKEN" --insecure -s $APISERVER/api/v1/namespaces/default/pods 不可以，因为default账号没有列出pods的权限
        修改deployment
          spec:
            serviceAccountName: mysa
            containers:
              - name: nginxtest
                image: nginx:1.18-alpine
                imagePullPolicy: IfNotPresent
                ports:

      token+证书的方式
        证书的位置在: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
        token的位置在: /var/run/secrets/kubernetes.io/serviceaccount/token

        curl --header "Authorization: Bearer $TOKEN" --cacert  /var/run/secrets/kubernetes.io/serviceaccount/ca.crt   $APISERVER/api/v1/namespaces/default/pods 

Pod
  最小调度单位
  好处：
    1、 方便部署、扩展和收缩、方便调度等，反正各种方便
    2、Pod中的容器共享数据和网络空间，统一的资源管理与分配
  pause容器作用
    1、扮演Pid=1的，回收僵尸进程
    2、基于Linux的namespace的共享

  创建Pod
    apiVersion: v1
    kind: Pod
    metadata:
      name: myngx
    spec:
      containers:
      - name: ngx
        image: "nginx:1.18-alpine"

  kubectl describe pod xxxx  查看pod详细
  kubectl logs   xxx 查看日志
  kubectl exec -it xxx  -- sh  //进入pod

  多容器 
    apiVersion: v1
    kind: Pod
    metadata:
      name: myngx
    spec:
      containers:
      - name: ngx
        image: "nginx:1.18-alpine"
      - name: alpine
        command: ["sh", "-c", "echo this is second && sleep 3600"]
        image: "alpine:3.12"
  
  配置数据卷
    spec:
      containers:
      - name: ngx
        image: "nginx:1.18-alpine"
        volumeMounts:
        - name: mydata
          mountPath: /data
      volumes:
      - name: mydata
        hostPath:
          path: /data
          type: Directory

  Deployment
    Pods：
      1、运行一组容器 、适合一次性开发
      2、很少直接用于生产

    Deployment
      1、运行一组相同的Pod（副本水平扩展）、滚动更新
      2、适合生产

    总结为：Deployment通过副本集管理和创建POD

  两个容器共享文件夹
    两个节点分别写入挂载点

    volumeMounts:
      - name: sharedata
        mountPath: /data

    volumes:
      - name:  sharedata
        emptyDir: {}
    同一个pod内的容器都能读写EmptyDir中 文件。常用于临时空间、多容器共享，如日志或者tmp文件需要的临时目录
  
  init容器的基本使用
    Init 容器是一种特殊容器，在 Pod 内的应用容器启动之前运行。Init 容器可以包括一些应用镜像中不存在的实用工具和安装脚本
    Init 容器与普通的容器非常像，除了如下两点：
      它们总是运行到完成。
      每个都必须在下一个启动之前成功完成。
    如果 Pod 的 Init 容器失败，kubelet 会不断地重启该 Init 容器直到该容器成功为止。 然而，如果 Pod 对应的 restartPolicy 值为 "Never"，Kubernetes 不会重新启动 Pod。

    initContainers:
    - name: init-mydb
      image: alpine:3.12
      command: ['sh', '-c', 'echo wait for db && sleep 35 && echo done']
    
    具体场景
      1、譬如 ping db
      2、譬如控制服务启动顺序

ConfigMap
  ConfigMap 是一种 API 对象，用来将非机密性的数据保存到健值对中。使用时可以用作环境变量、命令行参数或者存储卷中的配置文件。
  ConfigMap 将您的环境配置信息和 容器镜像 解耦，便于应用配置的修改。当您需要储存机密信息时可以使用 Secret 对象。
  
  使用的四个场景
    1、 容器 entrypoint 的命令行参数
    2、 容器的环境变量
    3、 映射成文件
    4、 编写代码在 Pod 中运行，使用 Kubernetes API 来读取 ConfigMap

  获取列表
    kubectl get cm
  创建一个cm 
    apiVersion: v1
    kind: ConfigMap
    metadata:
      name: mycm
    data:
      # 每一个键对应一个简单的值,以字符串的形式体现
      username: "shenyi"
      userage: "19"

    也可以这样 
      data:
        username: "shenyi"
        userage: "19“
        user.info: |
          name=shenyi
          age=19

  写入(和image同级）
    env:
      - name: USER_NAME
        valueFrom:
          configMapKeyRef:
            name: mycm           #  ConfigMap的名称
            key: username # 需要取值的键

  映射成文件
    volumeMounts:
      - name: cmdata
        mountPath: /data

    volumes:
      - name: cmdata
        configMap:
          name: mycm
          items:
            - key: user.info
              path: user.txt
  
  全部映射文件和subpath
    不指定具体的key
      volumes:
        - name: cmdata
          configMap:
            name: mycm
      所有文件都被 映射进去了，文件名就是key名
    
    不指定key 。也想挂载其中一个配置
      https://kubernetes.io/zh/docs/concepts/storage/volumes/#using-path
      用于指定所引用的卷内的子路径，而不是其根路径

      volumeMounts:
        - mountPath: /data/user.txt
          name: cmdata
          subPath: user.info
      
      volumes:
        - name: cmdata
          configMap:
            name: mycm
  
  用程序读取(体外) 
    下载客户端包 go get k8s.io/client-go@v0.18.6
    开启 api代理 kubectl proxy --address='0.0.0.0' --accept-hosts='^*$' --port=8009

    初始化客户端
      func getClient() *kubernetes.Clientset{
        config:=&rest.Config{
          Host:“http://124.70.204.12:8009”,    //IP自行改掉
        }
        c,err:=kubernetes.NewForConfig(config)
        if err!=nil{
          log.Fatal(err)
        }
        return c
      }

  用程序读取(体内) 
    1、token 在这个位置/var/run/secrets/kubernetes.io/serviceaccount/token
    2、APISERVER的地址这么拼接https://$KUBERNETES_SERVICE_HOST:$KUBERNETES_PORT_443_TCP_PORT
    证书的位置在: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt

    需要创建一个账户
      注意体内是：ServiceAccount 账户(体外是UserAccount)
      这个账户需要对ConfigMap拥有权限
      创建一个 cmuser，拥有对configmap的操作—限定在default这个命名空间里
    
    拼凑一些变量
      func init() {
        api_server=fmt.Sprintf("https://%s:%s",
          os.Getenv("KUBERNETES_SERVICE_HOST"),os.Getenv("KUBERNETES_PORT_443_TCP_PORT"))
          f,err:=os.Open("/var/run/secrets/kubernetes.io/serviceaccount/token")
          if err!=nil{
            log.Fatal(err)
        }
          b,_:=ioutil.ReadAll(f)
          token=string(b)
      }

    交叉编译
      set GOOS=linux
      set GOARCH=amd64
      go build -o cmtest cm.go

  调用API监控cm的变化
    基本代码
      fact:=informers.NewSharedInformerFactory(getClient(), 0)
      cmInformer:=fact.Core().V1().ConfigMaps()
      cmInformer.Informer().AddEventHandler(&CmHandler{})

      fact.Start(wait.NeverStop)
      select {}

    回调
      type CmHandler struct{}
      func(this *CmHandler) OnAdd(obj interface{}){}
      func(this *CmHandler) OnUpdate(oldObj, newObj interface{}){
        
      }
      func(this *CmHandler)	OnDelete(obj interface{}){}

Secret
  Secret 对象类型用来保存敏感信息，例如密码、OAuth 令牌和 SSH 密钥。 将这些信息放在 secret 中比放在 Pod 的定义或者 容器镜像 中来说更加安全和灵活。 参阅 Secret 设计文档 获取更多详细信息。
  Secret 是一种包含少量敏感信息例如密码、令牌或密钥的对象。 这样的信息可能会被放在 Pod 规约中或者镜像中。 用户可以创建 Secret，同时系统也创建了一些 Secret

  apiVersion: v1
  kind: Secret
  metadata:
    name: mysecret
  type: Opaque
  data:
    user: "shenyi"
    pass: "123"
  这样会报错，需要 先base64编码
  echo shenyi | base64 && echo 123 | base64 
  把得到的值替换即可

  如果一定要写明文则如下
    apiVersion: v1
    kind: Secret
    metadata:
      name: mysecret
    type: Opaque
    stringData:
      user: "shenyi"
      pass: "123"

  命令获取secret内容
    kubectl get secret mysecret -o yaml
    kubectl get secret mysecret -o json

  挂载文件
    - name: USER
      valueFrom:
        secretKeyRef:
          name: mysecret
          key: user
    
    volumes:
      - name: users
        secret:
          secretName: mysecret
  
  basic-auth认证
    configmap
      手工配nginx 
        location / {
          auth_basic      "xxxxooooo";
          auth_basic_user_file conf/htpasswd;
        }
      
      其中密码 我们常用的是通过apache的工具htpasswd或者openssl passwd命令生成
      htpasswd提供了一个变种的MD5加密算法(apr1)
      sudo yum -y install httpd-tools
      Apache的Web服务器内置的工具,用于创建和更新储存用户名和用户基本认证的密码文件

      创建一个密码文件  
      htpasswd -c auth shenyi
      这时产生了一个 auth文件

      再添加一个  用户(此时不用-c参数)
      htpasswd  auth lisi

      搞成一个ConfigMap
      默认配置文件在/etc/nginx/nginx.conf
      其中 主配置文件引用了 /etc/nginx/conf.d/default.conf 文件 

      拷贝并修改
        server {
            listen       80;
            server_name  localhost;
            location / {
              auth_basic      "test auth";
              auth_basic_user_file /etc/nginx/basicauth;
                root   /usr/share/nginx/html;
                index  index.html index.htm;
            }
            error_page   500 502 503 504  /50x.html;
            location = /50x.html {
                root   /usr/share/nginx/html;
            }
        }

      挂载
        volumeMounts:
          - name: nginxconf
            mountPath: /etc/nginx/conf.d/default.conf
            subPath: ngx
          - name: basicauth
            mountPath: /etc/nginx/basicauth
            subPath: auth

      卷
        volumes:
          - name: nginxconf
            configMap:
              defaultMode: 0655
              name: nginxconfig
          - name: basicauth
            configMap:
                defaultMode: 0655
                name: bauth
      
      访问测试
        curl --basic -u shenyi:123456  http://10.244.2.85

    secret
      kubectl  create secret generic secret-basic-auth  --from-file=auth
      curl --basic -u shenyi:123456  http://10.244.2.91

  拉取私有镜像、创建Docker Secret 
    https://hub.docker.com/signup  并且登录

    1、docker pull alpine:3.12 
    2、docker login --username=shenyisyn  (输入密码)
    3、docker tag alpine:3.12 shenyisyn/myalpine:3.12

    https://hub.docker.com/repository/create 创建私有镜像库
 
    docker push shenyisyn/myalpine:3.12  发布
    docker rmi shenyisyn/myalpine:3.12 刚才打标签的tag给删掉 

    kubectl create secret docker-registry dockerreg \
      --docker-server=https://index.docker.io/v1/\
      --docker-username=shenyisyn \
      --docker-password=xxxxx \
      --docker-email=65480539@qq.com

    kubectl get secret  dockerreg -o jsonpath={.data.*} | base64 -d

    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: myalpine
    spec:
      selector:
        matchLabels:
          app: myalpine
      replicas: 1
      template:
        metadata:
          labels:
            app: myalpine
        spec:
          containers:
            - name: alpine
              image: shenyisyn/myalpine:3.12
              imagePullPolicy: IfNotPresent
              command: ["sh","-c","echo this is alpine && sleep 36000"]
          imagePullSecrets:
              - name: dockerreg

Service
  提供负载均衡和服务自动发现

  apiVersion: v1
  data:
    h1: this is h1
    h2: this is h2
  kind: ConfigMap
  metadata:
      name: html

  apiVersion: v1
  kind: Service
  metadata:
    name: nginx-svc
  spec:
    type: ClusterIP
    ports:
      - port: 80
        targetPort: 80
    selector:  #service通过selector和pod建立关联
      app: nginx

  ClusterIP：通过集群的内部 IP 暴露服务，选择该值时服务只能够在集群内部  访问。 这也是默认的 ServiceType

  宿主机访问k8s的Service的基本方法 
    sudo yum install  bind-utils  -y
    nslookup nginx-svc
    会发现找不到

    处理办法 
      kubectl get svc -n kube-system 获取kube-dns的地址
      sudo vi /etc/resolv.conf  用于设置DNS服务器IP地址、DNS域名和设置主机的域名搜索顺序 我们加一个进去 
      nameserver 10.96.0.10
      执行 nslookup nginx-svc.default.svc.cluster.local 

  无头Service
    所谓的无头服务 通过指定 ClusterIP的值为“None”来创建 Headless Service

    apiVersion: v1
    kind: Service
    metadata:
      name: nginx-svc
    spec:
      clusterIP: "None"
      ports:
        - port: 80
          targetPort: 80
      selector:  #service通过selector和pod建立关联
        app: nginx

    作用
      1. 有些程序 需要自己来决定到底 使用哪个IP 譬如golang  可以使用  net.LookupIP(“服务名”)，来获取 IP ,然后自己来决定到底使用哪个
      2. StatefulSet 状态下。POD互相访问

PV
  PersistentVolume（持久化卷），是对底层的共享存储的一种抽象，  由管理员进行创建和配置。
  然后由 卷插件  如local、NFS 等具体的底层技术来实现 

  apiVersion: v1
  kind: PersistentVolume
  metadata:
    name: local-pv
  spec:
    capacity:
      storage: 1Gi
    volumeMode: Filesystem
    accessModes:
      - ReadWriteOnce
    persistentVolumeReclaimPolicy: Delete
    storageClassName: local-storage
    local:
      path: /mnt/disks/ssd1

  capacity
    它的单位有:
      P,T,G,M,K或 Pi,Ti,Gi,Mi,Ki 区别
      加i的是以1024为换算单位 

    如 (1Mi)
    1M=1024K=1024×1024byte

    1M 则是1000*1000

  accessModes
    ReadWriteOnce -- 卷可以被一个节点以读写方式挂载；
    ReadOnlyMany -- 卷可以被多个节点以只读方式挂载；
    ReadWriteMany -- 卷可以被多个节点以读写方式挂载。

  PersistentVolume 对象的回收策略
    Retained（保留）、Recycled（回收）或 Deleted（删除）

  节点亲和性
    之前我们调度节点时用过nodeSelector  ，设定标签进行匹配。这种方式过于”粗暴简单”。使用NodeAffinity来进行控制颗粒度更小（对于local模式 ，我们必须要设置）
    软策略 (有最好，没有也无所谓)
      如果没有满足调度要求的节点的话，就会忽略按正常调度
      preferredDuringSchedulingIgnoredDuringExecution
      preferredDuringSchedulingRequiredDuringExecution (一旦后面标签改了，有满足条件的节点了，就会重新调度到该节点上)
    硬策略 
      如果没有满足条件的节点的话，就不断重试直到满足条件为止 
      requiredDuringSchedulingIgnoredDuringExecution  （如果一开始满足的，后面node标签发生变化了，也无妨，继续运行）
      requiredDuringSchedulingRequiredDuringExecution（一旦变了，不符合条件了。则重新选择）

  查看标签 
    kubectl get node --show-labels=true
  打标签语法：
    kubectl label nodes <node-name> <label-key>=<label-value>
    kubectl label nodes jtthink2 pv=local
  删除语法
    kubectl label nodes <node-name> <label-key>-
    kubectl label nodes jtthink2 pv-

  matchExpressions
    In: label的值在某个列表中
    NotIn：label的值不在某个列表中
    Exists：某个label存在
    DoesNotExist：某个label不存在
    Gt：label的值大于某个值（字符串比较）
    Lt：label的值小于某个值（字符串比较） 
  
  PVC
    Persistent Volume提供存储资源(并实现)
    Persistent Volume Claim 描述需要的存储标准，然后从现有PV中匹配或者动态建立新的资源，最后将两者进行绑定

    PV和PVC中
      spec关键字段要匹配 。
      storageClassName字段必须一致  

  StorageClass
    理解为创建PV的模板   
    https://kubernetes.io/zh/docs/concepts/storage/storage-classes/

    provisioner:指的是卷插件  (如NFS，local)
    reclaimPolicy:  回收策略。 
    volumeBindingMode ：绑定模式
      Immediate :一旦创建PVC 就绑定
      WaitForFirstConsumer：就是延迟绑定，直到使用该 PVC 的 Pod 被创建
    parameters：参数（不同的存储方式有N多个不同参数，这里不讲了。大家自行看文档）

HPA
  Pod 水平自动扩缩（Horizontal Pod Autoscaler） 可以
  
  1、基于 CPU 利用率自动扩缩 ReplicationController、Deployment、ReplicaSet 和 StatefulSet 中的 Pod 数量。
  2、 除了 CPU 利用率，也可以基于其他应程序提供的自定义度量指标 来执行自动扩缩。
  3、 Pod 自动扩缩不适用于无法扩缩的对象，比如 DaemonSet。

  metrics-server
    k8s里。可以通过Metrics-Server服务采集节点和Pod的内存、磁盘、CPU和网络的使用率等

    注意：
      Metrics API 只可以查询当前的度量数据，并不保存历史数据
      Metrics API URI 为 /apis/metrics.k8s.io/ 
      必须部署 metrics-server 才能使用该 API，metrics-server 通过调用 Kubelet Summary API 获取数据

    部署方式
      kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

    kubectl top pod    (还可以写node)

    kubectl autoscale deployment ngx1 --min=2 --max=5 --cpu-percent=20

  限制POD资源
    resources:
      requests:
          cpu: "200m"
          memory: "256Mi"
      limits:
          cpu: "400m"
          memory: "512Mi“

    requests来设置各容器需要的最小资源
    limits用于限制运行时容器占用的资源
    1物理核=1000个微核(millicores)      1000m=1CPU

  sudo yum -y install httpd-tools
  里面包含了一个 apache ab 工具  做简单压测
  ab -n 10000 -c 10  http://web1/
  kubectl autoscale deployment web1 --min=1 --max=5 --cpu-percent=20

  yaml的方式创建HPA
    kubectl api-versions | grep autoscaling

    autoscaling/v1         #只支持通过cpu伸缩
    autoscaling/v2beta1    #支持通过cpu、内存 和自定义数据来进行伸缩。
    autoscaling/v2beta2     #beta1的进一步 （一般用它）

    apiVersion: autoscaling/v2beta2
    kind: HorizontalPodAutoscaler
    metadata:
      name: web1hpa
      namespace: default
    spec:
      minReplicas: 1
      maxReplicas: 5
      scaleTargetRef:
        apiVersion: apps/v1
        kind: Deployment
        name: web1
      metrics:
        - type: Resource
          resource:
            name: cpu
            target:
              type: Utilization
              averageUtilization: 50   #使用率
        - type: Resource
          resource:
            name: memory
            target:
              type: Utilization
              averageUtilization: 50   #使用率

    使用量
      metrics:
        - type: Resource
          resource:
            name: cpu
            target:
              type: AverageValue
              averageValue: 230m   #使用量
        - type: Resource
          resource:
            name: memory
            target:
              type: AverageValue
              averageValue: 400m   #使用量

  关于自定义指标
    自定义指标 比较主流的方式是使用prometheus
    有几项需要安装:
      node-exporter：prometheus的export，收集Node级别的监控数据
      prometheus：监控服务端，从node-exporter拉数据并存储为时序数据。
      kube-state-metrics：将prometheus中可以用PromQL查询到的指标数据转换成k8s对应的数据
      k8s-prometheus-adpater：聚合进apiserver，即custom-metrics-apiserver实现(也可以用自定义CRD来实现)

CRD
  CRD  是 Kubernetes 的一种资源(CustomResourceDefinition )，允许我们基于它自定义新的资源类型
  CRD就是 我们对自定义资源的定义

  apiVersion: apiextensions.k8s.io/v1
  kind: CustomResourceDefinition
  metadata:
    # 名字必需与下面的 spec 字段匹配，并且格式为 '<名称的复数形式>.<组名>'
    name: proxies.extensions.jtthink.com
  spec:
    # 分组名，在REST API中也会用到的，格式是: /apis/分组名/CRD版本
    group: extensions.jtthink.com
    # 列举此 CustomResourceDefinition 所支持的版本
    versions:
      - name: v1
        # 是否有效
        served: true
        storage: true
        schema:
          openAPIV3Schema:
            type: object
            properties:
              spec:
                type: object
                properties:
                  name:
                    type: string
                  age:
                    type: integer
    # 范围是属于namespace的 ,可以是 Namespaced 或 Cluster
    scope: Namespaced
    names:
      # 复数名
      plural: proxies
      # 单数名
      singular: proxy
      # 类型名
      kind: MyRoute
      # kind的简称，就像service的简称是svc
      shortNames:
        - mr
  
  kubernetes控制器管理器是一个守护进程，内嵌随kubernetes一起发布的核心控制回路
  具体的控制器通过API Server监视集群的状态,并尝试进行更改以将当前状态转为期望状态。目前kubernetes自带的控制器包括副本控制器，节点控制器，命名空间控制器和服务账号控制器等
  控制器会监视资源创建/更新/删除事件,并触发Reconcile函数作为响应,整个调整过程被称作"Reconcile loop"
  譬如RS，当收到一个关于ReplicaSet的事件或者关于ReplicaSet创建pod事件时，就会触发一个Reconcile函数，利用该函数用来调整状态使之可以和期望状态匹配

  kube-scheduler是kubernets中的关键模块，遵从一套机制为pod提供调度服务
  1. 我们通过某个手法发布pod
  2. ControllerManager会把pod加入调度队列
  3. scheduler通过机制决定到底要调度到哪个node，然后写入etcd
  4. 被选上的节点里的kubelet得到消息，然后干活(pull image这些，正式启动pod)
  总结起来就是做过滤和打分

NodeAffinity
  节点亲和性
    目前有两种类型的节点亲和性，分别为 
    requiredDuringSchedulingIgnoredDuringExecution  （必须满足）
    preferredDuringSchedulingIgnoredDuringExecution （有最好，没有也无所谓 ）

    affinity:
      nodeAffinity:
        requiredDuringSchedulingIgnoredDuringExecution:
          nodeSelectorTerms:
            - matchExpressions:
                - key: app
                  operator: In
                  values:
                    - ngx
        
        preferredDuringSchedulingIgnoredDuringExecution:
          - weight: 1
            preference:
              matchExpressions:
              - key: age
                operator: In
                values:
                - 19

    未来会支持requiredDuringSchedulingRequiredDuringExecution
    类似于刚才的 requiredDuringSchedulingIgnoredDuringExecution
    它会将 pod 从不再满足 pod 的节点亲和性要求的节点上驱逐

  节点污点和容忍度
    节点亲和性 使 Pod 被吸引到一类特定的节点。  
    Taint（污点）则相反，它使节点能够排斥一类特定的 Pod。
    kubectl describe node jtthink1 | grep Taints 查看指定节点上的污点
  
    NoSchedule ：一定不能被调度。
    PreferNoSchedule：尽量不要调度。
    NoExecute：不仅不会调度，还会驱逐Node上已有的Pod。

    内置污点
      node.kubernetes.io/not-ready：节点未准备好。这相当于节点状态 Ready 的值为 "False"。
      node.kubernetes.io/unreachable：节点控制器访问不到节点. 这相当于节点状态 Ready 的值为 "Unknown"。
      node.kubernetes.io/out-of-disk：节点磁盘耗尽。
      node.kubernetes.io/memory-pressure：节点存在内存压力。
      node.kubernetes.io/disk-pressure：节点存在磁盘压力。
      node.kubernetes.io/network-unavailable：节点网络不可用。
      node.kubernetes.io/unschedulable: 节点不可调度。
      node.cloudprovider.kubernetes.io/uninitialized：如果 kubelet 启动时指定了一个 "外部" 云平台驱动， 它将给当前节点添加一个污点将其标志为不可用。在 cloud-controller-manager 的一个控制器初始化这个节点后，kubelet 将删除这个污点。

    打污点
      kubectl taint node jtthink1 name=shenyi:NoSchedule
    删除该污点
       kubectl taint node jtthink1 name:NoSchedule-

    tolerations:
      - key: "name"
        operator: "Equal"
        value: "shenyi"
        effect: "NoSchedule"

POD亲和性
  Pod 间亲和性与反亲和性使你可以 基于已经在节点上运行的 Pod 的标签 来约束 Pod 可以调度到的节点，而不是基于节点上的标签
  Pod 间亲和性与反亲和性需要大量的处理，这可能会显著减慢大规模集群中的调度。 因此不建议在超过数百个节点的集群中使用它们

k8s从1.18—1.20
  删除rancher
    docker stop rancher的容器ID  && docker rm rancher的容器ID   

  reset
    主机执行：
      驱散 kubectl drain jtthink2 --delete-local-data –force
      kubectl delete nodes jtthink2

    reset (每台机器都要执行)
      sudo kubeadm reset
      sudo rm /etc/cni/net.d -fr

  卸载之前装的kubeadm  所有机器都要执行
    sudo yum -y remove kubelet-1.18.6  kubeadm-1.18.6  kubectl-1.18.6

  开始安装 
    sudo yum -y install kubelet-1.20.2  kubeadm-1.20.2  kubectl-1.20.2
    （两台机器都要执行）
    允许数据包转发(切换到root)
    #echo 1 > /proc/sys/net/ipv4/ip_forward
    #modprobe br_netfilter
    #echo 1 > /proc/sys/net/bridge/bridge-nf-call-iptables

    然后把kubelet 设置为开机启动
    #systemctl daemon-reload
    #systemctl enable kubelet

  初始化集群
    主机执行：
    kubeadm init --image-repository registry.cn-hangzhou.aliyuncs.com/google_containers  --kubernetes-version=1.20.2 --pod-network-cidr=10.244.0.0/16 --service-cidr=10.96.0.0/12  

  清除主机污点 
    kubectl taint nodes --all node-role.kubernetes.io/master-   (后面一个 – 是需要的)
  
  给工作节点打标签
    kubectl label node jtthink2 node-role.kubernetes.io/node=node

  安装Flannel
    会出现coredns pod的错误，解决方法
      
    来到子节点机器，执行
      sudo ifconfig cni0 down
      sudo ip link delete cni0

    然后删除之前的POD 就可以了
      kubectl delete pod coredns-54d67798b7-f7r6s coredns-54d67798b7-g2tr2 -n kube-system

  导入rancher2.5.5
    docker run -itd --privileged  -p 9443:443 \
      -v /home/shenyi/rancher:/var/lib/rancher \
      --restart=unless-stopped  -e CATTLE_AGENT_IMAGE="registry.cn-hangzhou.aliyuncs.com/rancher/rancher-agent:v2.5.5"  registry.cn-hangzhou.aliyuncs.com/rancher/rancher:v2.5.5
    请确保/home/shenyi/rancher  这个目录已经存在

    导入 kubectl create clusterrolebinding cluster-admin-binding --clusterrole cluster-admin --user kubernetes-admin
