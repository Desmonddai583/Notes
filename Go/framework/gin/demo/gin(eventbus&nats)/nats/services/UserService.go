package services

import (
	"context"
	"eventbus/models"
)

type UserService struct {}
func(this *UserService) GetUserInfo(ctx context.Context,req *UserRequest) ( *UserResponse,  error){
		 user:=&models.UserModel{UserId:101,UserName:"shenyi"}
		 return  &UserResponse{Result:user},nil
}