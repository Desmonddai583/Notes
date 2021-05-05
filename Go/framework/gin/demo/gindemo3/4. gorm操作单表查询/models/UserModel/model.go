package UserModel
type UserModelImpl struct {
	UserId int `gorm:"column:user_id;type:int;primaryKey;autoIncrement" json:"id" form:"id"`
	UserName string `gorm:"column:user_name;unique;type:varchar(50)"  json:"name" form:"name" binding:"min=4"`
	UserPwd string `gorm:"column:user_pwd;type:varchar(50)" json:"-" `
	UserAddtime string `gorm:"column:user_addtime;type:datetime" json:"addtime" `
}
func(*UserModelImpl) TableName() string {
	return "users"
}

func New(attrs ...UserModelAttrFunc) *UserModelImpl {
	u:= &UserModelImpl{}
	UserModelAttrFuncs(attrs).Apply(u)
	return  u
}
func(this *UserModelImpl) Mutate(attrs ...UserModelAttrFunc) *UserModelImpl{
	UserModelAttrFuncs(attrs).Apply(this)
	return this
}

