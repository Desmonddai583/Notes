package main

import (
	"fmt"

	"github.com/siddontang/go-log/log"
	. "github.com/xwb1989/sqlparser"
	"gomysql.jtthink.com/util"
)

func main() {
	//sql := "select user_id,user_name from  usersa  u where id<800 and id>50  " +
	//	" and name='abc'  and age=19  order by u.id desc  limit 0,10"
	sql := "select * from users"
	stmt, err := Parse(sql)
	if err != nil {
		log.Fatal(err)
	}
	switch stmt := stmt.(type) {
	case *Select:
		sqls := util.AliasedTableSQl(stmt)
		for _, sql := range sqls {
			fmt.Println(sql)
		}
	default:
		fmt.Println("default")
	}
}
