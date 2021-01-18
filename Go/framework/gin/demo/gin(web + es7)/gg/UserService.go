package gg

import "es.jtthink.com/AppInit"

type UserService struct {
}

func NewUserService() *UserService {
	return &UserService{}
}
func (this *UserService) GetUserById(uid int) (*UserModel, error) {
	user := NewUserModel()
	db := AppInit.GetDB().Table("users").Where("user_id=?", uid).First(&user)
	return user, db.Error
}
