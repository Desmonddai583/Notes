package gg

import "github.com/graphql-go/graphql"

type GArgs struct {
	args graphql.FieldConfigArgument
}

func ArgsBuilder() *GArgs { //初始化
	return &GArgs{args: make(graphql.FieldConfigArgument)}
}
func (this *GArgs) addArg(typeStr string, names ...string) {
	t := &graphql.Scalar{}
	if typeStr == "int" {
		t = graphql.Int
	} else if typeStr == "string" {
		t = graphql.String
	}
	for _, name := range names {
		this.args[name] = &graphql.ArgumentConfig{Type: t}
	}

}
func (this *GArgs) StringArgs(names ...string) *GArgs {
	this.addArg("string", names...)
	return this
}
func (this *GArgs) IntArgs(names ...string) *GArgs {
	this.addArg("int", names...)
	return this
}
func (this *GArgs) Build() graphql.FieldConfigArgument {
	return this.args
}
