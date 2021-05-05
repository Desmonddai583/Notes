package code

func getUserRoleIDFromDB(userId int) (int, error) {
	return userId + 1000, nil //假设 这步是从数据库取的
}

const (
	ADMIN_ROLE = 1 //管理员角色
	GUEST_ROLE = 0 //游客角色
)

//判断是否 内置管理员
func IsAdmin(userId int) bool {
	return userId < 10
}

//根据用户ID获取角色ID
func GetUserRoleID(userId int) int {
	if IsAdmin(userId) {
		return ADMIN_ROLE
	} else {
		if rid, err := getUserRoleIDFromDB(userId); err == nil {
			return rid
		}
	}
	return GUEST_ROLE
}
