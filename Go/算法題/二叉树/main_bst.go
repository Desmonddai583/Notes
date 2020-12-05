package main

import (
	"basego/Tree"
)

func main()  {
	root:=Tree.NewBSTree(6)
	Tree.AddBSTree(Tree.NewBSTree(8),root)
	Tree.AddBSTree(Tree.NewBSTree(9),root)
	//Tree.AddBSTree(Tree.NewBSTree(10),root)
	Tree.AddBSTree(Tree.NewBSTree(4),root)
  Tree.AddBSTree(Tree.NewBSTree(3),root)
	//Tree.AddBSTree(Tree.NewBSTree(5),root)
	//Tree.AddBSTree(Tree.NewBSTree(13),root)
	//Tree.AddBSTree(Tree.NewBSTree(6),root)
	//Tree.AddBSTree(Tree.NewBSTree(1),root)
	//Tree.AddBSTree(Tree.NewBSTree(7),root)
	//Tree.AddBSTree(Tree.NewBSTree(12),root)
	//Tree.AddBSTree(Tree.NewBSTree(14),root)
	//Tree.AddBSTree(Tree.NewBSTree(16),root)
	//Tree.AddBSTree(Tree.NewBSTree(11),root)

	level:=root.Level()
	Tree.PrintBSTree([]*Tree.BSTree{root},level,1)

	Tree.DeleteNode(6,root)
	level=root.Level()
	Tree.PrintBSTree([]*Tree.BSTree{root},level,1)



}
