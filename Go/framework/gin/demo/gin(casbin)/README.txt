Casbin是一个强大的、高效的开源访问控制框架，其权限管理机制支持多种访问控制模型
文档地址： https://casbin.org/docs/zh-CN/overview

安装
  go get github.com/gin-gonic/gin
  go get github.com/casbin/casbin

模型定义
  [request_definition]
  r = sub, obj, act
  分表是
  访问实体 (Subject)，访问资源 (Object) 和访问方法 (Action)

  GET /users
  举个栗子： 譬如shenyi这个用户要访问/users,GET 请求

  则:
  shenyi sub
  /users obj
  GET act

  [policy_definition]
  p = sub, obj, act

  效果一样  是对策略的定义

  [role_definition]  角色定义
  g = _, _

  _, _表示角色继承关系的前项和后项，即前项继承后项角色的权限

  admin>=member
  member>=guest
  
  [policy_effect]
  e = some(where (p.eft == allow))
  
  对policy生效范围的定义
  上面表示：如果存在任意一个决策结果为allow的匹配规则，则最终决策结果为allow

  p.eft就是决策结果

  示例
  !some(where (p.eft == deny))  表示 任何一个决策结果都不能是deny

  [matchers]
  m = r.sub == p.sub && r.obj == p.obj && r.act == p.act

  这个是 请求和策略的匹配规则

策略文件
  g, shenyi, admin
  g, lisi, member
  //上面这两个 代表定义了两个人：shenyi和lisi ，分表角色是admin和member

  p, memeber, /depts, GET
  p, memeber, /depts/:id, GET
  //这代表 member可以访问的 path和请求方式
  p, admin, /depts, POST
  p, admin, /depts/:id, PUT
  p, admin, /depts/:id, DELETE
  //同上 
  g, admin, member
  g,member,guest
  // 这代表 admin同时也拥有member的关系 

代码
  sub:= "lisi" // 想要访问资源的用户。
  obj:= "/depts" // 将被访问的资源。
	act:= "POST" // 用户对资源执行的操作。
	e:= casbin.NewEnforcer("resources/model.conf","resources/p.csv")

	ok:= e.Enforce(sub, obj, act)
	if ok {
		log.Println("运行通过")
	}

使用Gorm持久化权限策略
  https://casbin.org/docs/zh-CN/adapters
  https://github.com/casbin/gorm-adapter

  安装
    go get github.com/casbin/gorm-adapter/v3
    它内部也依赖了gorm本身

  要升级下casbin 使用v2版本
    go get github.com/casbin/casbin/v2
  
  adap,err:=gormadapter.NewAdapterByDB(Gorm)
	if err!=nil{
		log.Fatal()
	}
	e,err:= casbin.NewEnforcer("resources/model.conf",adap)
	if err!=nil{
		log.Fatal()
	}
	err=e.LoadPolicy()
	if err!=nil{
		log.Fatal()
	}

初始化权限数据
  管理API
    https://casbin.org/docs/zh-CN/management-api

  RBAC API
    https://casbin.org/docs/zh-CN/rbac-api

  测试
    func initPolicy()  {
      E.AddPolicy("member","/depts","GET")
      E.AddPolicy("admin","/depts","POST")
      E.AddRoleForUser("zhangsan","member")
    }

  说明
    角色有4个：
      1	guest	  
      2	sysadmin	  系统管理员
      3	deptadmin	2	部门管理员
      4 useradmin	2	会员管理员


      路由有几个
      1	部门列表	/detps	    GET	
      2	部门详细	/depts/:id   GET	
      3	新增部门	/depts	    POST	
      5	会员列表	/users	    GET	
      6	会员详细	/users/:id    GET	
      7	新增会员	/users	    POST	

      只要不是guest 那么任何列表和详细都是可以看得
      各自的新增必须对应的管理员才能操作

  初始化用户角色
    角色之间是有上下级关系的

    有两种方式
      1、取出pid=0 的数据，然后递归遍历，再次查询数据库 ，直至遍历出所有下级
      2、加载全部。然后 用程序 递归

  路由和角色初始化
    select a.r_uri,a.r_method,c.role_name from routers a,router_roles b,roles c 
      where a.r_id=b.router_id and b.role_id=c.role_id
      order by role_name

  uri参数支持
    https://casbin.org/docs/zh-CN/function

    [matchers]
    m = g(r.sub, p.sub) && keyMatch2(r.obj, p.obj) && r.act == p.act

  简化策略数据
    p	deptadmin	/depts	GET
    p	deptadmin	/depts	POST
    这样很麻烦,如果改成类似 p	deptadmin	/depts  GET,POST 这种形式就会更好

    修改匹配规则两种方案
      一种是用它内置的函数
        regexMatch(k1,k2) k2是正则
        具体写法regexMatch(r.act, p.act)
        假设r.act是 GET，并假设p.act是POST和GET 
        这好比r.act是否符合p.act的正则匹配
        p	deptadmin	/depts  (GET|POST)  

      自定义匹配函数
        https://casbin.org/docs/zh-CN/function

租户权限
  基本模式
    1、独立数据库（database）
    每个租户有不同数据库，数据隔离级别最高 ，但成本也高

    2、共享数据库，隔离数据架构（scheme、表）
    多个或所有租户共享同一个数据库，但每个租户有不同的数据表

    3、共享数据库和数据架构
    大家都用同一张表 ，通过TenantID区分租户的数据。这种方案成本最低，共享程度最高、隔离级别最低的模式

  测试代码
    sub:= "lisi" // 想要访问资源的用户。
    obj:= "/depts" // 将被访问的资源。
    act:= "POST" // 用户对资源执行的操作。
    e,_:= casbin.NewEnforcer("resources/model_t.conf","resources/p_t.csv")

    ok,err:= e.Enforce(sub,"domain2", obj, act)
    if err==nil && ok {
      log.Println("运行通过")
    }

  初始化角色
    格式
      g, shenyi, admin,domain1
      g, lisi, admin,domain2

    初始化方法
      1、先取出所有租户列表,然后遍历
      2、组装策略

      基本代码
        roles:=make([]*models.Role,0)
        lib.Gorm.Table("roles a,tenants b").
          Where("a.tenant_id=b.tenant_id").
          Where("a.role_pid=?",0).Select("a.*,b.tenant_name").
          Find(&roles)

策略生效范围
  可用来实现角色特例权限

  [policy_effect]
  e = some(where (p.eft == allow))

  官方的解释是：
  如果存在任意一个决策结果为allow的匹配规则，则最终决策结果为allow，即allow-override。 其中p.eft 表示策略规则的决策结果，可以为allow 或者deny .  默认是allow
