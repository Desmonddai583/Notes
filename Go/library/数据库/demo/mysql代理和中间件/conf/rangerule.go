package conf

import (
	"github.com/xwb1989/sqlparser"
)

type Rule interface {
}
type RangeRule struct {
	Column string
	Ranges []*Range
}

func NewRangeRule(column string) *RangeRule {
	return &RangeRule{Column: column, Ranges: make([]*Range, 0)}
}
func (this *RangeRule) AddRange(max int, min int, node string) {
	this.Ranges = append(this.Ranges, &Range{Max: max, Min: min, Node: node})
}

func (this *RangeRule) GetNode(value int, operator string) []interface{} {
	getIndex := -1
	for index, r := range this.Ranges { //这一步先取出 命中在哪个区间
		if value >= r.Min && value <= r.Max {
			getIndex = index
			break
		}
	}
	if getIndex < 0 {
		return nil
	}
	if operator == sqlparser.EqualStr { //如果是 =
		return []interface{}{this.Ranges[getIndex].Node}
	}
	if operator == sqlparser.LessThanStr || operator == sqlparser.LessEqualStr { //如果是<= 和<
		return this.GetNodes(getIndex, true)
	}
	if operator == sqlparser.GreaterEqualStr || operator == sqlparser.GreaterThanStr { //如果是 >= 和>
		return this.GetNodes(getIndex, false)
	}
	return nil
}
func (this *RangeRule) GetNodes(index int, less bool) []interface{} {
	result := make([]interface{}, 0)
	if less {
		for _, r := range this.Ranges[0 : index+1] { //这个部分看PPT思路说明
			result = append(result, r.Node)
		}
	} else {
		for _, r := range this.Ranges[index:] {
			result = append(result, r.Node)
		}
	}
	return result

}

type Range struct {
	Max  int
	Min  int
	Node string
}
