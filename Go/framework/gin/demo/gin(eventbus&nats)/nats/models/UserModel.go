package models

import "encoding/json"

type UserModel struct {
	UserId   string
	UserName string
	Score    string
}

func (this *UserModel) Json() []byte {
	b, _ := json.Marshal(this)
	return b
}

func NewUserModel(name string) *UserModel {
	return &UserModel{UserName: name}
}
func ParseForUser(data []byte) (*UserModel, error) {
	user := &UserModel{}
	err := json.Unmarshal(data, user)
	if err != nil {
		return nil, err
	}
	return user, nil
}
