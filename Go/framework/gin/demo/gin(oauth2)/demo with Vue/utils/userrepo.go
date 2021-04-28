package utils

import (
	"fmt"
	"goauth/models"
)

func AddNewUser(userName string, pwd1 string, pwd2 string, userID string, sourceName string) (*models.UserModel, error) {
	if pwd1 != pwd2 {
		return nil, fmt.Errorf("密码不一致")
	}
	source := &models.Source{}
	if sourceName != "" { //说明有来源， 则要判断。否则不判断
		if err := Gorm.Table("sources").Where("source_name=?", sourceName).First(source).Error; err != nil {
			return nil, fmt.Errorf("来源不合法:%s", err.Error())
		}
	}
	user := &models.UserModel{UserName: userName, UserPwd: pwd1, SourceId: source.SourceId, SourceUserId: userID}
	if err := Gorm.Table("users").Create(user).Error; err != nil {
		return nil, fmt.Errorf("注册用户失败:%s", err.Error())
	} else {
		return user, nil
	}
}

//@sourceName 来源名，需要判断是否存在
//@sourceUserID  来源网站请求获得的 userID
//下面代码是为了能够演示方便、方便看懂，请自行优化
func GetUserName(sourceName string, sourceUserID string) *models.UserModel {
	source := &models.Source{}
	if err := Gorm.Table("sources").Where("source_name=?", sourceName).First(source).Error; err != nil {
		panic(fmt.Errorf("error source:%s", err.Error()))
	}
	userModel := &models.UserModel{}
	if err := Gorm.Table("users").Where("source_id=? and source_userid=?",
		source.SourceId, sourceUserID).First(userModel).Error; err != nil {
		//代表 用户 没有在我们网站登录
		return nil
	} else {
		return userModel
	}

}
