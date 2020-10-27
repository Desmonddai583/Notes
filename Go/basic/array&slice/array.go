package main

import "fmt"

// go語言是值傳遞，除非是指針，否則不會改變傳入參數本身
// 这里如果是arr []int代表的是切片，只有定义了长度才代表是数组
func printArray(arr [5]int) {
	arr[0] = 100
	for i, v := range arr {
		fmt.Println(i, v)
	}
}

func main() {
	// 默認值爲0
	var arr1 [5]int
	// 使用:=時需要賦初值
	arr2 := [3]int{1, 3, 5}
	// 不確定長度時
	arr3 := [...]int{2, 4, 6, 8, 10}
	var grid [4][5]int

	fmt.Println("array definitions:")
	fmt.Println(arr1, arr2, arr3)
	fmt.Println(grid)

	fmt.Println("printArray(arr1)")
	printArray(arr1)

	fmt.Println("printArray(arr3)")
	printArray(arr3)

	fmt.Println("arr1 and arr3")
	fmt.Println(arr1, arr3)
}
