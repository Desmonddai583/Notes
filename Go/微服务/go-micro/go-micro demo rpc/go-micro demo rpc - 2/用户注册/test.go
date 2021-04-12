package main

import (
	"fmt"
	"log"

	"gopkg.in/go-playground/validator.v9"
	"tools.jtthink.com/AppLib"
)

type Users struct {
	Username string   `validate:"required,min=6,max=20" vmsg:"用户名规则不正确" `
	Userpwd  string   `validate:"required,min=6,max=18" vmsg:"用户密码必须6位以上"`
	Usertags []string `validate:"required,min=1,max=5,unique,dive,usertag" vmsg:"用户标签不合法"`
}

func main() {
	userTags := []string{"aa", "bb", "cc", "dd", "ee"}

	user := &Users{Username: "shenyi", Userpwd: "123123", Usertags: userTags}
	valid := validator.New()

	_ = AppLib.AddRegexTag("usertag", "^[\u4e00-\u9fa5a-zA-Z0-9]{2,4}$", valid)
	//加入自定义的正则验证tag
	_ = AppLib.AddRegexTag("username", "[a-zA-Z]\\w{5,19}", valid)

	err := AppLib.ValidErrMsg(user, valid.Struct(user))
	if err != nil {
		log.Fatal(err)
	}
	fmt.Println("验证成功")
}
