package Tree

import (
	"fmt"
	"math"
)

type BTree struct {
	Value int
	Left  *BTree
	Right *BTree
}

func (this *BTree) String() {
	fmt.Printf("二叉树:值是%d\n", this.Value)
	var leftValue interface{}
	if this.Left != nil {
		leftValue = this.Left.Value
	}
	var rightValue interface{}
	if this.Right != nil {
		rightValue = this.Right.Value
	}
	fmt.Printf("左节点:%v   右节点:%v \n", leftValue, rightValue)
} //以字符串的形式打印
func max(a int, b int) int {
	if a >= b {
		return a
	}
	return b
}

//获取层高
func (this *BTree) Level() int {
	if this == nil {
		return 0
	}
	return max(this.Left.Level(), this.Right.Level()) + 1
}

func printBlanks(count float64) {
	for i := 0.0; i < count; i++ {
		fmt.Print(" ")
	}
}

//打印树
func PrintBTree(nodes BTrees, maxlevel int, currlevel int) {
	if len(nodes) == 0 || nodes.IsAllNil() {
		return
	}
	floor := maxlevel - currlevel
	leftBlanks := math.Pow(2.0, float64(floor)) - 1    //元素左边的空格数
	rightBlanks := math.Pow(2.0, float64(floor+1)) - 1 //元素左边的空格数
	printBlanks(leftBlanks)                            //先打左边空格

	newNodes := make(BTrees, 0)
	for _, node := range nodes {
		if node != nil {
			fmt.Print(node.Value)
			newNodes = append(newNodes, node.Left, node.Right)
		} else {
			printBlanks(1) //打印一个空格
			newNodes = append(newNodes, nil, nil)
		}
		printBlanks(rightBlanks) //打右边空格
	}
	fmt.Print("\n")

	//画线
	lineNums := math.Pow(2, float64(floor-1))
	for i := 1.0; i <= lineNums; i++ {
		for _, node := range nodes {
			printBlanks(leftBlanks - i) //左边线做空格
			if node == nil {
				printBlanks(lineNums*2 + i + 1)
				continue
			}
			if node.Left != nil {
				fmt.Print("/")
			} else {
				printBlanks(1)
			}
			printBlanks(2*i - 1) //左边线的右空格
			if node.Right != nil {
				fmt.Print("\\") //右斜线
			} else {
				printBlanks(1)
			}
			printBlanks(2*lineNums - i)
		}
		fmt.Print("\n")
	}
	PrintBTree(newNodes, maxlevel, currlevel+1)
}

//先序遍历
func (this *BTree) Preorder() {
	if this == nil {
		return
	}
	fmt.Printf("%d->", this.Value) //先打印出值
	this.Left.Preorder()           //递归
	this.Right.Preorder()          //递归
}

//中序遍历
func (this *BTree) Inorder() {
	if this == nil {
		return
	}
	this.Left.Inorder()            //递归
	fmt.Printf("%d->", this.Value) //先打印出值
	this.Right.Inorder()           //递归
}

//后序遍历
func (this *BTree) Postorder() {
	if this == nil {
		return
	}
	this.Left.Postorder()          //递归
	this.Right.Postorder()         //递归
	fmt.Printf("%d->", this.Value) //先打印出值
}

func (this *BTree) ConnectLeft(treeOrValue interface{}) *BTree {
	if bt, ok := treeOrValue.(*BTree); ok {
		this.Left = bt
	} else if v, ok := treeOrValue.(int); ok {
		this.Left = NewBTree(v)
	}
	return this
}
func (this *BTree) ConnectRight(treeOrValue interface{}) *BTree {
	if bt, ok := treeOrValue.(*BTree); ok {
		this.Right = bt
	} else if v, ok := treeOrValue.(int); ok {
		this.Right = NewBTree(v)
	}
	return this

}

func NewBTree(value int) *BTree {
	return &BTree{Value: value}
}

type BTrees []*BTree //二叉树集合类型
func (this BTrees) String() {
	for _, bt := range this {
		bt.String()
	}
	fmt.Printf("当前一共有%d个节点", len(this))
}

//判断子元素是否都为nil
func (this BTrees) IsAllNil() bool {
	for _, bt := range this {
		if bt != nil {
			return false
		}
	}
	return true
}

func NewBTrees(values ...int) BTrees {
	btrees := make(BTrees, len(values))
	for index, v := range values {
		btrees[index] = NewBTree(v)
	}
	return btrees
}
