package main

import (
	"fmt"

	"github.com/siddontang/go-log/log"
	. "github.com/xwb1989/sqlparser"
	"gomysql.jtthink.com/util"
)

func main() {
	sql := "select user_id,user_name from  users  u where id=60 order by u.id desc  limit 0,10"
	stmt, err := Parse(sql)
	if err != nil {
		log.Fatal(err)
	}

	switch stmt := stmt.(type) {
	case *Select:
		//buf:=NewTrackedBuffer(nil)
		//stmt.SelectExprs.Format(buf)
		//fmt.Println(buf.String())

		//for _,node:=range stmt.From{
		//	getTable:=node.(*AliasedTableExpr)
		//
		//fmt.Println(getTable.As.String())
		//}

		sqls := util.AliasedTableSQl(stmt)

		for _, sql := range sqls {
			fmt.Println(sql)
		}

	default:
		fmt.Println("default")
	}
}
