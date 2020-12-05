package main

import (
	"net"
	"fmt"
	"time"
	"runtime"
)

func main()  {
	lis,err:=net.Listen("tcp","127.0.0.1:8099")
	if err!=nil{
		fmt.Println(err)
		return
	}
	defer lis.Close()
	fmt.Println("创建监听成功，等待客户端连接")
	go func() {
		for{
			fmt.Printf("当前任务数:%d\n",runtime.NumGoroutine())
			time.Sleep(time.Second*2)
		}
	}()
	for {
		client,err:=lis.Accept()
		if err!=nil{
			fmt.Println(err)
			return
		}
	   go func(c net.Conn){
			defer c.Close()
			buf := make([]byte, 4096)
			n, err := c.Read(buf)
			if err != nil {
				fmt.Println(err)
				return
			}

			c.Write([]byte(ReadHtml(GetRequestPath(string(buf[:n])))))

		}(client)

	}



}
