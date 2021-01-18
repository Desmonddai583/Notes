package gg

import (
	"log"

	"github.com/graphql-go/graphql"
)

type LogModel struct {
	Ip       string `json:"ip"`
	Status   string `json:"status"`
	Duration string `json:"duration"`
	Method   string `json:"method"`
	Url      string `json:"url"`
	Time     string `json:"time"`
	Agent    string `json:"agent"`
	Referer  string `json:"referer"`
}

func NewLogModelGraphQL() *graphql.Object {
	return graphql.NewObject(graphql.ObjectConfig{
		Name: "LogModel",
		Fields: graphql.Fields{
			"Ip":       StringField(),
			"Status":   StringField(),
			"Duration": StringField(),
			"Method":   StringField(),
			"Url":      StringField(),
			"Time":     StringField(),
			"Msg":      StringField(),
			"Agent":    StringField(),
		},
	})
}

func NewLogModelQuery() *graphql.Object {
	return graphql.NewObject(graphql.ObjectConfig{
		Name: "LogQuery",
		Fields: graphql.Fields{
			"Search": &graphql.Field{Type: graphql.NewList(NewLogModelGraphQL()),
				Args: ArgsBuilder().StringArgs("url", "method").IntArgs("size").Build(),
				Resolve: func(p graphql.ResolveParams) (i interface{}, e error) {
					return NewLogService().
						WithUrlQuery(p.Args["url"]).
						WithMethodQuery(p.Args["method"]).
						WithSize(p.Args["size"]).
						Search()
				}},
		},
	})
}

//创建查询规则
func NewLogQuerySchema() graphql.Schema {
	s, err := graphql.NewSchema(graphql.SchemaConfig{
		Query: NewLogModelQuery(),
	})
	if err != nil {
		log.Fatal(err)
	}
	return s
}
