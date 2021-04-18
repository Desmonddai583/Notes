package lib

import (
	"gcasbin/models"
	"log"
)

type RoleRel struct {
	PRole  string
	Role   string
	Domain string //租户的域
}

func (this *RoleRel) String() string {
	return this.PRole + ":" + this.Role + ":" + this.Domain
}
func AllTenants() (ret []*models.Tenant) { //获取所有租户
	db := Gorm.Find(&ret)
	if db.Error != nil {
		log.Fatal(db)
	}
	return
}

//获取角色---不带租户
func GetRoles(pid int, m *[]*RoleRel, pname string) {
	proles := make([]*models.Role, 0)
	Gorm.Where("role_pid=?", pid).Find(&proles)
	if len(proles) == 0 {
		return
	}
	for _, item := range proles {
		if pname != "" {
			*m = append(*m, &RoleRel{pname, item.RoleName, ""})
		}
		GetRoles(item.RoleId, m, item.RoleName)
	}

}

//获取角色---带租户
func GetRolesWithDomain() []*RoleRel {
	ts := AllTenants() //获取 所有 租户
	roleRels := make([]*RoleRel, 0)
	for _, t := range ts { //遍历租户
		t_roleRels := make([]*RoleRel, 0)
		getRolesWithDomain(0, &t_roleRels, "", t)
		roleRels = append(roleRels, t_roleRels...)
	}
	return roleRels
}
func getRolesWithDomain(pid int, m *[]*RoleRel, pname string, t *models.Tenant) {
	proles := make([]*models.Role, 0)
	//注意这里，根据每个租户ID进行获取
	Gorm.Where("role_pid=? and tenant_id=?", pid, t.TenantId).Find(&proles)
	if len(proles) == 0 {
		return
	}
	for _, item := range proles {
		if pname != "" {
			*m = append(*m, &RoleRel{pname, item.RoleName, t.TenantName})
		}
		getRolesWithDomain(item.RoleId, m, item.RoleName, t)
	}

}

//获取用户和角色对应关系
func GetUserRoles() (users []*models.Users) {
	Gorm.Select("a.user_name,c.role_name ").Table("users a,user_roles b ,roles c ").
		Where("a.user_id=b.user_id and b.role_id=c.role_id").
		Order("a.user_id desc").Find(&users)
	return
}
func GetUserRolesWithDomain() (users []*models.Users) {
	Gorm.Select("a.user_name,c.role_name,d.tenant_name ").Table(" users a,user_roles b ,roles c,tenants d ").
		Where(" a.user_id=b.user_id and b.role_id=c.role_id and c.tenant_id=d.tenant_id ").
		Order("a.user_id desc").Find(&users)
	return
}

//获取路由和角色对应关系
func GetRouterRoles() (routers []*models.Routers) {
	Gorm.Select("a.r_uri,a.r_method,c.role_name").
		Table("routers a,router_roles b,roles c ").
		Where(" a.r_id=b.router_id and b.role_id=c.role_id").
		Order(" role_name").Find(&routers)
	return
}

//带 租户的 路由角色获取
func GetRouterRolesWithDomain() (routers []*models.Routers) {
	Gorm.Select(" a.r_uri,a.r_method,c.role_name,d.tenant_name ").
		Table("routers a,router_roles b,roles c ,tenants d   ").
		Where(" a.r_id=b.router_id and b.role_id=c.role_id and c.tenant_id=d.tenant_id").
		Order(" role_name").Find(&routers)
	return
}
