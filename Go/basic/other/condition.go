package main

import (
	"fmt"
	"io/ioutil"
)

func grade(score int) string {
	// go中的switch会自带break，如果不想要的话需要加fallthrough，fallthrough不会判断下一条 case 的表达式结果是否为 true
	g := ""
	switch {
	case score < 0 || score > 100:
		panic(fmt.Sprintf(
			"Wrong score: %d", score))
	case score < 60:
		g = "F"
	case score < 80:
		g = "C"
	case score < 90:
		g = "B"
	case score <= 100:
		g = "A"
	default:
		panic(fmt.Sprintf(
			"Wrong Score: %d", score))
	}
	return g
}

func main() {
	// If "abc.txt" is not found,
	// please check what current directory is,
	// and change filename accordingly.
	const filename = "abc.txt"
	// if條件中可以執行多個表達式
	if contents, err := ioutil.ReadFile(filename); err != nil {
		fmt.Println(err)
	} else {
		fmt.Printf("%s\n", contents)
	}

	fmt.Println(
		grade(0),
		grade(59),
		grade(60),
		grade(82),
		grade(99),
		grade(100),
		// Uncomment to see it panics.
		// grade(-3),
	)
}
