package gg

import (
	"fmt"
	"log"

	"github.com/graphql-go/graphql"
)

type UserModel struct {
	Id   int    `gorm:"column:user_id;AUTO_INCREMENT;PRIMARY_KEY"`
	Name string `gorm:"column:user_name;type:varchar(50)"`
}

func NewUserModel() *UserModel {
	return &UserModel{}
}

//映射实体  第一步:
func NewUserModelGraphQL() *graphql.Object {

	return graphql.NewObject(graphql.ObjectConfig{
		Name: "UserModel",
		Fields: graphql.Fields{
			"id":   &graphql.Field{Type: graphql.Int},
			"name": &graphql.Field{Type: graphql.String},
		},
	})
}

//创建 查询 对象
func NewUserModelQuery() *graphql.Object {
	return graphql.NewObject(graphql.ObjectConfig{
		Name: "UserQuery",
		Fields: graphql.Fields{
			"User": &graphql.Field{Type: NewUserModelGraphQL(),
				Args: graphql.FieldConfigArgument{"id": &graphql.ArgumentConfig{Type: graphql.Int}},
				Resolve: func(p graphql.ResolveParams) (i interface{}, e error) {
					if id, ok := p.Args["id"]; ok {
						return NewUserService().GetUserById(id.(int))
					} else {
						return nil, fmt.Errorf("id param error")
					}
				}},
		},
	})
}

//创建查询规则
func NewUserQuerySchema() graphql.Schema {
	s, err := graphql.NewSchema(graphql.SchemaConfig{
		Query: NewUserModelQuery(),
	})
	if err != nil {
		log.Fatal(err)
	}
	return s
}
