package main

import "fmt"

// map除了slice,map,function之外都可以作爲key，struct類型不包括上述類型也可以作爲key

func main() {
	m := map[string]string{
		"name":    "ccmouse",
		"course":  "golang",
		"site":    "imooc",
		"quality": "notbad",
	}

	m2 := make(map[string]int) // m2 == empty map

	var m3 map[string]int // m3 == nil, nil可以與其他類型混合運算，所以在這裏即便是nil也是安全的

	fmt.Println("m, m2, m3:")
	fmt.Println(m, m2, m3)

	fmt.Println("Traversing map m")
	// map的元素是無序的
	for k, v := range m {
		fmt.Println(k, v)
	}

	fmt.Println("Getting values")
	courseName := m["course"]
	fmt.Println(`m["course"] =`, courseName)
	// key不存在時，獲得value類型的初始值
	if causeName, ok := m["cause"]; ok {
		fmt.Println(causeName)
	} else {
		fmt.Println("key 'cause' does not exist")
	}

	fmt.Println("Deleting values")
	name, ok := m["name"]
	fmt.Printf("m[%q] before delete: %q, %v\n",
		"name", name, ok)

	delete(m, "name")
	name, ok = m["name"]
	fmt.Printf("m[%q] after delete: %q, %v\n",
		"name", name, ok)
}
