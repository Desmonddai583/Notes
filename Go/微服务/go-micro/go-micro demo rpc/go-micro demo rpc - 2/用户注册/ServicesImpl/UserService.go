package ServicesImpl

import (
	"context"
	"time"

	"tools.jtthink.com/AppInit"
	"tools.jtthink.com/DBModels"
	"tools.jtthink.com/Services"
)

type UserService struct {
}

func (this *UserService) UserReg(ctx context.Context, user *Services.UserModel, rsp *Services.RegReponse) error {
	users := DBModels.Users{UserName: user.UserName, UserPwd: user.UserPwd, UserDate: time.Now()}
	if err := AppInit.GetDB().Create(&users).Error; err != nil {
		rsp.Message = err.Error()
		rsp.Status = "error"
	} else {
		rsp.Message = ""
		rsp.Status = "success"
	}

	return nil
}
