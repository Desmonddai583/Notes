package tree

// go中首字母大写代表public，否则为private
// 每个目录只能有一个包
// main包包含执行入口
// 为struct定义的方法必须在同一个包内，可以是不同文件

import "fmt"

// Node 定义node
type Node struct {
	Value       int
	Left, Right *Node
	// 直接放类型的话默认field name就会是类型命
	// contactInfo
}

// type contactInfo struct {
// 	name string
// }

// Print 输出
// 如果不使用到receiver可以直接只寫類型，etc. func(Node) Print() {...}
func (node Node) Print() {
	fmt.Print(node.Value, " ")
}

// SetValue 赋值
func (node *Node) SetValue(value int) {
	if node == nil {
		fmt.Println("Setting Value to nil " +
			"node. Ignored.")
		return
	}
	node.Value = value
}

// CreateNode 工厂方法创建node
// go中不需要考虑在堆还是栈中分配，这里即使是局部变量，但是go
// 会自行判断如果返回的话就会在堆中创建，否则在栈中创建
func CreateNode(value int) *Node {
	return &Node{Value: value}
}
