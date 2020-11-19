package main

import (
	"fmt"
	"os"

	"bufio"

	"imooc.com/ccmouse/learngo/lang/functional/fib"
)

// 加了defer的表达式会在函数结束时才调用
// defer会把表达式放在栈中，所以执行顺序是先进后出
// defer即使在函数中有return或是panic也可以触发
// 参数是在遇到defer语句时计算
// 所以下面的case结果就是30的倒序，而不是全部都是30
func tryDefer() {
	for i := 0; i < 100; i++ {
		defer fmt.Println(i)
		if i == 30 {
			// Uncomment panic to see
			// how it works with defer
			// panic("printed too many")
		}
	}
}

func writeFile(filename string) {
	file, err := os.OpenFile(filename,
		os.O_EXCL|os.O_CREATE|os.O_WRONLY, 0666)

	// 可以创建custom error，e.g.
	// err = errors.New("custom error")
	if err != nil {
		if pathError, ok := err.(*os.PathError); !ok {
			panic(err)
		} else {
			fmt.Printf("%s, %s, %s\n",
				pathError.Op,
				pathError.Path,
				pathError.Err)
		}
		return
	}
	defer file.Close()

	writer := bufio.NewWriter(file)
	defer writer.Flush()

	f := fib.Fibonacci()
	for i := 0; i < 20; i++ {
		fmt.Fprintln(writer, f())
	}
}

func main() {
	tryDefer()
	writeFile("fib.txt")
}
