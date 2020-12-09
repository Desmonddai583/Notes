package main

import (
	"github.com/antlr/antlr4/runtime/Go/antlr"
	"log"
	"mygin/BeanExpr/FuncExpr"
	"reflect"
	"strconv"
	"strings"
)


type FuncExprListener struct {
	*FuncExpr.BaseBeanExprListener
	funcName string
	args []reflect.Value

}
func (this *FuncExprListener) ExitFuncCall(ctx *FuncExpr.FuncCallContext) {
	//log.Println("函数名是:",	ctx.GetStart().GetText())
	this.funcName=ctx.GetStart().GetText()
}
func(this *FuncExprListener) ExitFuncArgs(ctx *FuncExpr.FuncArgsContext) {
	for i:=0;i<ctx.GetChildCount();i++{
		token:=ctx.GetChild(i).GetPayload().(*antlr.CommonToken)
		var value reflect.Value
		switch  token.GetTokenType() {
		case FuncExpr.BeanExprLexerStringArg:
			stringArg:=strings.Trim(token.GetText(),"'")
			value=reflect.ValueOf(stringArg)
			break
		case FuncExpr.BeanExprLexerIntArg:
			v,err:=strconv.ParseInt(token.GetText(),10,64)
			if err!=nil{
				panic("parse int64 error")
			}
			value=reflect.ValueOf(v)
			break
		case FuncExpr.BeanExprLexerFloatArg:
			v,err:=strconv.ParseFloat(token.GetText(),64)
			if err!=nil{
				panic("parse float64 error")
			}
			value=reflect.ValueOf(v)
			break
		default:
			continue
		}
		this.args=append(this.args,value)
	}


}
func(this *FuncExprListener) Run()  {
	if f,ok:=FuncMap[this.funcName];ok{
		v:=reflect.ValueOf(f)
		if v.Kind()==reflect.Func{
			v.Call(this.args)
		}
	}

}
var FuncMap map[string]interface{}
func main()  {
	 FuncMap= map[string]interface{}{
	 	"test": func(name string,age int64) {
			log.Println("this is ",name," and  age is :",age)
		},
	 }
	is:=antlr.NewInputStream("test('shenyi',19)")


    lexer:=FuncExpr.NewBeanExprLexer(is)
	ts := antlr.NewCommonTokenStream(lexer, antlr.TokenDefaultChannel)
	p := FuncExpr.NewBeanExprParser(ts)
	lis:=&FuncExprListener{}
	antlr.ParseTreeWalkerDefault.Walk(lis, p.Start())

    lis.Run()





}