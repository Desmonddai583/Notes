package handlers

import (
	"ginskill/src/models/UserModel"
	"ginskill/src/result"
	"github.com/gin-gonic/gin"
)

func UserList(c *gin.Context) {
	user:=UserModel.New()
	result.Result(c.ShouldBind(user)).Unwrap()
	// {message:"xxx",code:"100001",result:nil}
	if user.UserId>10{
		R(c)("userlist","100001","userlist")(OK2String)
	}else{
		R(c)("userlist","100001","userlist")(Error)
	}



}