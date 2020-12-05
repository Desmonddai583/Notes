package main

import (
	"com.jtthink.net/myhttpserver/core"
)

type NewsController struct {
	core.MyController
}

func(this *NewsController) GET()  {
   // this.Ctx.WriteString("this is newscontroller")
   p:=this.GetParam("username","no param","abc")
   this.Ctx.WriteString(p)

}

func(this *NewsController) POST()  {
	//this.Ctx.WriteString("this is newscontroller for POST")
	user:=UserMode{}
	this.JSONParam(&user)
	this.Ctx.WriteJSON(user)

}
