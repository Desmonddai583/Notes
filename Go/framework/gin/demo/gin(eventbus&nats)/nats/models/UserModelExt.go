package models

import (
	"github.com/golang/protobuf/proto"
	"strconv"
)

func NewUserModel(id string,name string ) *UserModel{
		intid,_:=strconv.Atoi(id)
		return &UserModel{UserId:int32(intid),UserName:name}
}
func(this *UserModel) Encode() ([]byte,error){
	return proto.Marshal(this)
}
func(this *UserModel) Deocde(b []byte) error{
	return proto.Unmarshal(b,this)
}