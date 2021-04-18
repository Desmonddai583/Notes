package lib

import (
	"log"

	"github.com/casbin/casbin/v2"
)

var E *casbin.Enforcer

func init() {

	initDB()
	adapter, err := gormadapter.NewAdapterByDB(Gorm)
	if err != nil {
		log.Fatal()
	}
	e, err := casbin.NewEnforcer("resources/model_t.conf", adapter)
	if err != nil {
		log.Fatal()
	}
	err = e.LoadPolicy()
	if err != nil {
		log.Fatal()
	}
	E = e
	initPolicyWithDomain()
}

//从我们的库里初始化 策略数据  ----- 不带租户
func initPolicy() {

	///下面 这部分是初始化 角色
	m := make([]*RoleRel, 0)
	GetRoles(0, &m, "") //获取角色 对应
	for _, r := range m {
		_, err := E.AddRoleForUser(r.PRole, r.Role)
		if err != nil {
			log.Fatal(err)
		}
	}
	/////// 初始化用户角色
	userRoles := GetUserRoles()
	for _, ur := range userRoles {
		_, err := E.AddRoleForUser(ur.UserName, ur.RoleName)
		if err != nil {
			log.Fatal(err)
		}
	}
	///// 初始化 路由角色
	routerRoles := GetRouterRoles()
	for _, rr := range routerRoles {
		_, err := E.AddPolicy(rr.RoleName, rr.RouterUri, rr.RouterMethod)
		if err != nil {
			log.Fatal(err)
		}
	}

}

//租户 初始化
func initPolicyWithDomain() {

	///下面 这部分是初始化 角色 关系
	//拼凑出这种格式
	// g, deptadmin, deptupdater,domain1
	//g, deptupdater, deptselecter,domain2
	//其中deptselecter 权限最低，然后是deptupdater ,最后是deptadmin
	roles := GetRolesWithDomain() //获取角色 对应
	for _, r := range roles {
		_, err := E.AddRoleForUserInDomain(r.PRole, r.Role, r.Domain) //看这一句，加了domain参数
		if err != nil {
			log.Fatal(err)
		}
	}
	/////// 初始化用户角色 ,格式和上面一样
	userRoles := GetUserRolesWithDomain()
	for _, ur := range userRoles {
		//这里也做了改变，增加了 domain参数
		_, err := E.AddRoleForUserInDomain(ur.UserName, ur.RoleName, ur.Domain)
		if err != nil {
			log.Fatal(err)
		}
	}
	///// 初始化 路由角色对应关系
	//格式 p	deptselecter	domain1	/depts	GET
	routerRoles := GetRouterRolesWithDomain()
	for _, rr := range routerRoles {
		_, err := E.AddPolicy(rr.RoleName, rr.Domain, rr.RouterUri, rr.RouterMethod)
		if err != nil {
			log.Fatal(err)
		}
	}

}
