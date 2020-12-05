package Tree

import (
	"fmt"
	"math"
)

type BSTree struct {
	Value int
	Left  *BSTree
	Right *BSTree
}
type BSTrees []*BSTree

//判断子元素是否都为nil
func (this BSTrees) IsAllNil() bool {
	for _, bt := range this {
		if bt != nil {
			return false
		}
	}
	return true
}
func NewBSTree(value int) *BSTree {
	return &BSTree{Value: value}
}
func (this *BSTree) Level() int {
	if this == nil {
		return 0
	}
	return max(this.Left.Level(), this.Right.Level()) + 1
}

//打印树
func PrintBSTree(nodes BSTrees, maxlevel int, currlevel int) {
	if len(nodes) == 0 || nodes.IsAllNil() {
		return
	}
	floor := maxlevel - currlevel
	leftBlanks := math.Pow(2.0, float64(floor)) - 1    //元素左边的空格数
	rightBlanks := math.Pow(2.0, float64(floor+1)) - 1 //元素左边的空格数
	printBlanks(leftBlanks)                            //先打左边空格

	newNodes := make(BSTrees, 0)
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
	PrintBSTree(newNodes, maxlevel, currlevel+1)
}

//递归加入节点
func AddBSTree(bst *BSTree, node *BSTree) *BSTree {
	if node == nil { //没有子节点了
		return bst
	}
	if bst.Value < node.Value {
		node.Left = AddBSTree(bst, node.Left) //左边节点都小于根

	} else if bst.Value > node.Value {
		node.Right = AddBSTree(bst, node.Right) //右边节点都大于根
	}
	return node
}

func SearchNodeWithParent(value int, node *BSTree, parent ...interface{}) (*BSTree, *BSTree, string) {
	if node == nil {
		return nil, nil, ""
	}
	if value < node.Value {
		return SearchNodeWithParent(value, node.Left, node, "left")
	} else if value > node.Value {
		return SearchNodeWithParent(value, node.Right, node, "right")
	} else {
		if len(parent) == 0 { //没有传参数
			return node, nil, ""
		}
		return node, parent[0].(*BSTree), parent[1].(string)

	}
}

//搜索节点
func SearchNode(value int, node *BSTree) *BSTree {
	if node == nil {
		return nil
	}
	if value < node.Value {
		return SearchNode(value, node.Left)
	} else if value > node.Value {
		return SearchNode(value, node.Right)
	} else {
		return node
	}
}

//获取父节点
func ParentNode(node *BSTree, root *BSTree) *BSTree {
	if node == nil || root == nil || node == root {
		return nil
	}
	//第二步
	if node == root.Left || node == root.Right {
		return root
	}
	//第三步 (递归，左递归->右递归
	get_left := ParentNode(node, root.Left)
	if get_left != nil {
		return get_left
	}
	return ParentNode(node, root.Right)

}

//没有任何子节点
func (this *BSTree) isLeaf() bool { //判断是否没有子节点
	if this.Left == nil && this.Right == nil {
		return true
	}
	return false
}

//返回 当前节点的子节点（要么左 要么右)
func (this *BSTree) getSingleChild() *BSTree {
	if this.Left != nil && this.Right == nil {
		return this.Left
	}
	if this.Left == nil && this.Right != nil {
		return this.Right
	}
	return nil
}

func DeleteNode(value int, treeRoot *BSTree) {
	node, parent, pos := SearchNodeWithParent(value, treeRoot)
	if node == nil { //没有节点
		return
	}

	if node.isLeaf() { //没有子节点，直接删
		if parent == nil {
			*treeRoot = *(*BSTree)(nil)
			return
		}
		if pos == "left" {
			parent.Left = nil
		} else {
			parent.Right = nil
		}
	} else if single := node.getSingleChild(); single != nil { //代表 需要删除的节点只有一个子节点 要么左 要么右
		if parent == nil {
			if node.Left != nil {
				*treeRoot = *node.Left
			} else {
				*treeRoot = *node.Right
			}
			return
		}
		if pos == "left" {
			parent.Left = single
		} else {
			parent.Right = single
		}
	} else {
		successor := MinNode(node.Right)
		DeleteNode(successor.Value, treeRoot)
		node.Value = successor.Value
	}

}

//先序
func (this *BSTree) Preorder(result *[]int) {
	if this == nil {
		return
	}
	*result = append(*result, this.Value)
	this.Left.Preorder(result)  //递归
	this.Right.Preorder(result) //递归
}

//中序
func (this *BSTree) Inorder(result *[]int) {
	if this == nil {
		return
	}
	this.Left.Inorder(result) //递归
	*result = append(*result, this.Value)
	this.Right.Inorder(result) //递归
}

//后序
func (this *BSTree) Postorder(result *[]int) {
	if this == nil {
		return
	}
	this.Left.Postorder(result)  //递归
	this.Right.Postorder(result) //递归
	*result = append(*result, this.Value)
}

//最大节点
func MaxNode(node *BSTree) *BSTree {
	if node.Right != nil {
		return MaxNode(node.Right)
	} else {
		return node
	}
}

//最小节点
func MinNode(node *BSTree) *BSTree {
	if node.Left != nil {
		return MinNode(node.Left)
	} else {
		return node
	}
}
