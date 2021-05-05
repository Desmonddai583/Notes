package Getter

import (
	"fmt"
	"ginskill/src/dbs"
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
type UserGetterImpl struct {}
func NewUserGetterImpl() *UserGetterImpl {
	return &UserGetterImpl{}
}
func(this *UserGetterImpl) GetUserList() (users []*UserModel.UserModelImpl){
	dbs.Orm.Find(&users)
	return
}
func(this *UserGetterImpl) GetUserByID(id int) *result.ErrorResult{
	user:=UserModel.New()
	db:=dbs.Orm.Where("user_id=?",id).Find(user)
	if db.Error!=nil || db.RowsAffected==0{
		return result.Result(nil,fmt.Errorf("not found user,id=%d",id))
	}
	return result.Result(user,nil)
}

