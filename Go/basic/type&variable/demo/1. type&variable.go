package main

import (
	"fmt"
	"math"
	"math/cmplx"
)

/*
Go語言類型
bool, string
(u)int, (u)int8, (u)int16, (u)int32, (u)int64, uintptr(指針)
byte(8位), rune(字符型，其他語言中的char只有1字節，go語言爲了應對多國應用，使用rune，它是4字節32位的)
float32, float64, complex64, complex128 (complex代表的是復數)
*/

// 外部定義變量不可以使用:=
var (
	aa = 3
	ss = "kkk"
	bb = true
)

func variableZeroValue() {
	var a int    // 0
	var s string // ""
	// %q會用雙引號包住字符串，%s則不會
	fmt.Printf("%d %q\n", a, s)
}

func variableInitialValue() {
	var a, b int = 3, 4
	// 這裏不需要加string的，go語言會自動推斷類型
	// var s string = "abc"
	fmt.Println(a, b)
}

func variableTypeDeduction() {
	var a, b, c, s = 3, 4, true, "def"
	fmt.Println(a, b, c, s)
}

func variableShorter() {
	// :=只有在賦初值時才可以使用
	a, b, c, s := 3, 4, true, "def"
	b = 5
	fmt.Println(a, b, c, s)
}

func euler() {
	fmt.Printf("%.3f\n",
		cmplx.Exp(1i*math.Pi)+1)
	c := 3 + 4i
	fmt.Println(cmplx.Abs(c)) // |3 + 4i| = sqrt(3^2 + 4^2) = 5
}

// go的類型轉換一定是強制的
func triangle() {
	var a, b int = 3, 4
	fmt.Println(calcTriangle(a, b))
}

func calcTriangle(a, b int) int {
	var c int
	c = int(math.Sqrt(float64(a*a + b*b)))
	return c
}

// go中的常量數值可以作爲各種類型使用
func consts() {
	const (
		filename = "abc.txt"
		a, b     = 3, 4
	)
	var c int
	c = int(math.Sqrt(a*a + b*b))
	fmt.Println(filename, c)
}

// iota代表從0開始自增的數字，我們甚至可以將它與一些表達式做結合
func enums() {
	const (
		cpp = iota
		_
		python
		golang
		javascript
	)

	const (
		b = 1 << (10 * iota)
		kb
		mb
		gb
		tb
		pb
	)

	fmt.Println(cpp, javascript, python, golang)
	fmt.Println(b, kb, mb, gb, tb, pb)
}

func main() {
	fmt.Println("Hello world")
	variableZeroValue()
	variableInitialValue()
	variableTypeDeduction()
	variableShorter()
	fmt.Println(aa, ss, bb)

	euler()
	triangle()
	consts()
	enums()
}
