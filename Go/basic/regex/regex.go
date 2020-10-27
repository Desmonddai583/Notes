package main

import (
	"fmt"
	"regexp"
)

const text = `
my email is ccmouse@gmail.com@abc.com
email1 is abc@def.org
email2 is    kkk@qq.com
email3 is ddd@abc.com.cn
`

func main() {
	// re, err := regexp.Compile("ccmouse@gmail.com@abc.com")
	// 如果使用MustCompile则正则表达式语法错误的话直接报错
	re := regexp.MustCompile(
		`([a-zA-Z0-9]+)@([a-zA-Z0-9]+)(\.[a-zA-Z0-9.]+)`)
	// re.FindString(text) 只会查找到第一个匹配的
	// re.FindAllString(text, -1) -1代表找到所有匹配的
	// FindAllStringSubmatch返回一个2维的slice
	match := re.FindAllStringSubmatch(text, -1)
	for _, m := range match {
		fmt.Println(m) // [ccmouse@gmail.com ccmouse gmail .com]
	}
}
