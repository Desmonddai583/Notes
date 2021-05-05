package Getter

import (
	"fmt"
	"ginskill/src/data/mappers"
	"ginskill/src/models/UserModel"
	"ginskill/src/result"
)

var UserGetter IUserGetter

func init() {
	UserGetter=NewUserGetterImpl()
}
type IUserGetter interface {
	GetUserList() []*UserModel.UserModelImpl
	GetUserByID(id int) *result.ErrorResult
}
type UserGetterImpl struct {
	userMapper *mappers.UserMapper
}
func NewUserGetterImpl() *UserGetterImpl {
	return &UserGetterImpl{userMapper:&mappers.UserMapper{}}
}
func(this *UserGetterImpl) GetUserList() (users []*UserModel.UserModelImpl){
	 this.userMapper.GetUserList().Query().Find(&users) //java mybatis
 	return
}
func(this *UserGetterImpl) GetUserByID(id int) *result.ErrorResult{
	user:=UserModel.New()
	 db:=this.userMapper.GetUserDetail(id).Query().Find(user)
	if db.Error!=nil || db.RowsAffected==0{
		return result.Result(nil,fmt.Errorf("not found user,id=%d",id))
	}

	return result.Result(user,nil)
}

