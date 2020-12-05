package main

import (
	"math/rand"
	"time"
	"sync"
	"fmt"
	"context"
)

func main()  {
	rand.Seed(time.Now().Unix())

	ctx,_:=context.WithTimeout(context.Background(),time.Second*3)

	var wg sync.WaitGroup
	wg.Add(1)
    go GenUsers(ctx,&wg)
	wg.Wait()

    fmt.Println("生成幸运用户成功")
}
func GenUsers(ctx context.Context,wg *sync.WaitGroup)  { //生成用户ID
fmt.Println("开始生成幸运用户")
   users:=make([]int,0)
   guser:for{
		select{
		   case <- ctx.Done(): //代表父context发起 取消操作

			 fmt.Println(users)
			   wg.Done()
		     break guser
			 return
		default:
			users=append(users,getUserID(1000,100000))
		}
   }

}
func getUserID(min int ,max int) int  {
	return rand.Intn(max-min)+min
}

