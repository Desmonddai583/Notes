package gg

import "github.com/graphql-go/graphql"

func IntField() *graphql.Field {
	return &graphql.Field{Type: graphql.Int}
}
func StringField() *graphql.Field {
	return &graphql.Field{Type: graphql.String}
}
func FloatField() *graphql.Field {
	return &graphql.Field{Type: graphql.Float}
}
