package main

import (
	"github.com/astaxie/beego"
	_ "sys/routers"
)

func main() {
	/*第一个参数是在HTML代码中编写的函数名称
	  第二个参数是在main.go代码中编写的函数名称*/
	beego.AddFuncMap("showNextPage", showNextPage)
	beego.AddFuncMap("showPrePage", showPrePage)
	beego.Run()
}

/*
1.在HTML模板中通过以下语法指定结果从哪个函数中获取
pageIndex={{nextpage .pageIndex .totalPages}}
2.在main.go中定义showNextPage函数
3.在main.go的beego.Run()代码执行之前添加映射关系

*/
func showNextPage(currentPage, totalPage int) int{
	currentPage = currentPage + 1
	if currentPage >= totalPage{
		currentPage = totalPage
	}
	return currentPage
}
func showPrePage(currentPage int) int{
	currentPage = currentPage - 1
	if currentPage <= 1{
		currentPage = 1
	}
	return  currentPage
}

