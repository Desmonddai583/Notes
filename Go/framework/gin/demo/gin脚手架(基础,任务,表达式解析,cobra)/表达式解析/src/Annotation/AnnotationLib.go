package Annotation

import (
	"github.com/antlr/antlr4/runtime/Go/antlr"
	"mygin/BeanExpr/FuncExpr"
)
type AnnotionListern struct {
	*BaseAnnotationListener
}
func ParseAnnotion(expr string )  {
	is:=antlr.NewInputStream(expr)
	lexer:=FuncExpr.NewBeanExprLexer(is)
	ts := antlr.NewCommonTokenStream(lexer, antlr.TokenDefaultChannel)
	p := NewAnnotationParser(ts)
	lis:=&AnnotionListern{}
	antlr.ParseTreeWalkerDefault.Walk(lis, p.Start())
}