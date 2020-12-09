package main

import (
	"github.com/antlr/antlr4/runtime/Go/antlr"
	"log"
	"mygin/BeanExpr/FuncExpr"
)

//这是一段  连接mongodb的 函数，注意:绝对没有执行
//func connect(cName string) (*mgo.Session, *mgo.Collection) {
//	session, err := mgo.Dial("$mongoHost") //Mongodb's connection
//	if err != nil {
//		panic(err)
//	}
//	session.SetMode(mgo.Monotonic, true)
//	//return a instantiated collect
//	return session, session.DB("m").C(cName)
//}
type FuncExprListener struct {
	*FuncExpr.BaseBeanExprListener
	funcName string
}
func (this *FuncExprListener) ExitFuncCall(ctx *FuncExpr.FuncCallContext) {
	log.Println("函数名是:",	ctx.GetStart().GetText())
	 this.funcName=ctx.GetStart().GetText()
	 }
func(this *FuncExprListener) Run()  {
     if f,ok:=FuncMap[this.funcName];ok{
     	f()
	 }
}
var FuncMap map[string]func()
func main()  {
	 FuncMap= map[string]func(){
	 	"test": func() {
			log.Println("this is test")
		},
	 }

	is:=antlr.NewInputStream("test()")
    lexer:=FuncExpr.NewBeanExprLexer(is)
	ts := antlr.NewCommonTokenStream(lexer, antlr.TokenDefaultChannel)
	p := FuncExpr.NewBeanExprParser(ts)
	lis:=&FuncExprListener{}
	antlr.ParseTreeWalkerDefault.Walk(lis, p.Start())

    lis.Run()





}