package main

import (
    . "mygin/src/classes"
    "mygin/src/goft"
    . "mygin/src/middlewares"
)

func main()  {

    //goft.GenTplFunc("src/funcs")  //自动生成一个 funcmap.go
    //return
     goft.Ignite().
        //可以在控制器 同时使用两个ORM
        Beans(goft.NewGormAdapter(),goft.NewXOrmAdapter()). // 实现简单的依赖注入
        Attach(NewUserMid()).//带生命周期的中间件
        Mount("v1",NewIndexClass(), //控制器，挂载到v1
              NewUserClass(),NewArticleCalss()).
         Task("0/3 * * * * *", goft.Expr(".ArticleClass.Test")).
        Launch()




}