package Models

type UserModel struct {
	UserId   int    `json:"uid"`
	UserName string `json:"uname" binding:"required"`
}

func NewUserModel() *UserModel {
	return &UserModel{}
}
