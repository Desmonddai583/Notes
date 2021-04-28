package models

type UserModel struct {
	UserId       int    `gorm:"column:user_id"`
	UserName     string `gorm:"column:user_name"`
	UserPwd      string `gorm:"column:user_pwd"`
	SourceId     int    `gorm:"column:source_id"`
	SourceUserId string `gorm:"column:source_userid"`
}
