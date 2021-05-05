package Setter

import (
	"ginskill/src/models/UserModel"
	"ginskill/src/result"
)

var UserSetter IUserSetter

func init() {
	UserSetter=NewUserSetterImpl()
}
type IUserSetter interface {
	SaveUser(*UserModel.UserModelImpl) *result.ErrorResult
}

type UserSetterImpl struct {

}

func NewUserSetterImpl() *UserSetterImpl {
	return &UserSetterImpl{}
}
func(this *UserSetterImpl) SaveUser(*UserModel.UserModelImpl) *result.ErrorResult{
	return result.Result(nil)
}