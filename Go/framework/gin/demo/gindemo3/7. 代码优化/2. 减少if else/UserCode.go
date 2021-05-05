package code

import (
	"fmt"
	"ginskill/src/result"
)

func getUserRoleIDFromDB(userId int) (int, error) {
	return userId + 1000, nil //假设 这步是从数据库取的
}

const (
	ADMIN_ROLE = 1 //管理员角色
	GUEST_ROLE = 0 //游客角色
)

//判断是否 内置管理员
func IsAdmin(userId int) error {
	if userId < 10 {
		return nil
	}
	return fmt.Errorf("not admin")
}

//根据用户ID获取角色ID
func GetUserRoleID(userId int) int {
	return result.Result(ADMIN_ROLE, IsAdmin(userId)).
		Unwrap_Or_Else(func() interface{} {
			return result.Result(getUserRoleIDFromDB(userId)).Unwrap_Or(GUEST_ROLE)
		}).(int)
	//if IsAdmin(userId){
	//	return ADMIN_ROLE
	//}else{
	//	if rid,err:=getUserRoleIDFromDB(userId);err==nil{
	//		return rid
	//	}
	//}
	//return GUEST_ROLE
}
