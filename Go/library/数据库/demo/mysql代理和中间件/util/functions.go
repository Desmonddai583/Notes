package util

import (
	"strconv"

	. "github.com/xwb1989/sqlparser"
	"gomysql.jtthink.com/conf"
)

var operator = []interface{}{"=", "<", "<=", ">", ">="}

//取表达式的字符串结果
func GetString(expr Expr) string {
	buf := NewTrackedBuffer(nil)
	expr.Format(buf)
	return buf.String()
}
func GetInt(expr Expr, defValue int) int {
	str := GetString(expr)
	istr, err := strconv.Atoi(str)
	if err != nil {
		return defValue
	}
	return istr
}

var config = conf.NewConfig() //获取配置
func ParseMutiWhere(where *Where) []interface{} {
	if where == nil {
		return nil
	}
	exps := ParseWhereToSlice(where.Expr) //这里做了改动1 :把where条件 生成出一个expr 集合。
	ret := make([]interface{}, 0)
	for _, exp := range exps { //改动点：每个expr都进行解析
		parsedNode := ParseWhere(exp)
		if parsedNode == nil || len(parsedNode) == 0 { //如果取出来的值 是空切片，则不作处理
			continue
		}
		if len(ret) == 0 {
			ret = parsedNode
		}
		ret = IntersectSlice(ret, parsedNode) //解析出来的条件取交集，重要!重要!重要!
	}

	return ret
}

//把where条件 拆分成切片 id > 60 and name = 'abc' and id < 80 and age = 19
// 则变成 ["id > 60 "," name = 'abc'", " id < 80" ,"age = 19"]
func ParseWhereToSlice(expr Expr) []Expr {
	exprList := make([]Expr, 0)
	temp := expr
	for {
		if andExpr, ok := temp.(*AndExpr); ok { //如果是and类型，则取右边
			exprList = append(exprList, andExpr.Right)
			temp = andExpr.Left
		} else {
			exprList = append(exprList, temp)
			break
		}
	}
	return exprList
}

func ParseWhere(expr Expr) []interface{} {
	if expr == nil {
		return nil
	}
	ce := expr.(*ComparisonExpr)          //如果是比较级条件 ，譬如a=1/a>1 都算
	rule := config.Rule.(*conf.RangeRule) //自己配置的字段,目前使用 范围分表规则
	column := rule.Column
	if GetString(ce.Left) == column { //如果where条件左边的字段 == 我们配置的范围字段，则取出对应的表名
		if Contains(operator, ce.Operator) { //这里代表 只支持 部分Operator
			node := rule.GetNode(GetInt(ce.Right, 0), ce.Operator) //node 就是真实物理表名
			return node
		}
	}
	return nil

}

func AliasedTableSQl(stmt *Select) []string {
	sqls := make([]string, 0)
	node := ParseMutiWhere(stmt.Where) //获取 where条件中的实际物理表
	//fmt.Println(node) //之类打印出来作为测试
	for _, te := range stmt.From {
		tableName := te.(*AliasedTableExpr).Expr.(TableName).Name.String() //获取表名
		as := te.(*AliasedTableExpr).As                                    //获取别名

		if mtables, ok := config.Models[tableName]; ok {
			for _, mtable := range mtables { //遍历 配置中对应的真实表
				//重要修改点、重要修改点、重要修改点、重要修改点
				//[]   ["users1"]  ["users2"]
				if node != nil && len(node) > 0 && !Contains(node, mtable) {
					continue
				}
				sql := forkSql(stmt, mtable, as) //拆分sql
				sqls = append(sqls, sql)
			}
		}
	}
	return sqls
}

func forkSql(stmt *Select, mtable string, as TableIdent) string {
	newsql := &Select{} //select
	newsql.SelectExprs = stmt.SelectExprs
	newTe := &AliasedTableExpr{
		As: as,
		Expr: TableName{
			Name: NewTableIdent(mtable)},
	} //自己构建出一个 TableExpr (目前写死是TableName)
	newsql.From = append(newsql.From, newTe) //select xxx,xx from xxx
	newsql.Where = stmt.Where                //select xxx,xx from xxx where xxx=xxx
	newsql.OrderBy = stmt.OrderBy            //select xxx,xx from xxx where xxx=xxx order by xx
	newsql.Limit = stmt.Limit                //select xxx,xx from xxx where xxx=xxx order by xx limit xxx

	buf := NewTrackedBuffer(nil)
	newsql.Format(buf)
	return buf.String()

}
