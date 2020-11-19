// goroutine背后使用的是协程(coroutine)
// 协程类似于轻量级的线程
// 为非抢占式多任务处理，由协程主动交出控制权
// 编译器/解释器/虚拟机层面的多任务
// go自己有实现一个调度器来调度协程
// 多个协程可以在一个或多个线程上执行
// go run -race goroutine.go 可以用来检测race condition问题

// go背后有一个调度器用来调度协程，他并非完全由用户自己切换控制权
// 可能的切换点有
// I/O, select, channel, 等待锁, 函数调用(有时), runtime.Gosched()
// 以上只是作为参考，不能保证切换，也不能保证在其他地方不切换

package main

import (
	"fmt"
	"runtime"
	"time"
)

func main() {
	// for i := 0; i < 1000; i++ {
	// 	go func(i int) {
	// 		for {
	// 			fmt.Printf("Hello from "+
	// 				"goroutine %d\n", i)
	// 		}
	// 	}(i)
	// }
	// time.Sleep(time.Minute)

	// 上面的Printf涉及IO操作，背后调度器会交出控制权
	// 下面这个例子中因为没有IO相关操作，所以需要显示调用runtime.Gosched交出控制权
	// 这里匿名函数如果不传i进去的话，就不会保留i运行时的值，并且在for跑完之后i会为10
	// 而此时如果是某个匿名函数正在执行，则会出现index out of range的错误
	var a [10]int
	for i := 0; i < 10; i++ {
		go func(i int) {
			for {
				a[i]++
				runtime.Gosched()
			}
		}(i)
	}
	time.Sleep(time.Minute)
	fmt.Println(a)
}
