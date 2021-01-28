package util

import (
	"github.com/siddontang/go-log/log"
	"github.com/siddontang/go-mysql/client"
	"github.com/siddontang/go-mysql/mysql"
	"github.com/siddontang/go-mysql/server"
	. "github.com/xwb1989/sqlparser"
)

type MyHandler struct {
	server.EmptyHandler
	conn *client.Conn
}

func NewMyHandler() MyHandler {
	conn, err := client.Connect("127.0.0.1:3306",
		"shenyi", "123123", "test")
	if err != nil {
		log.Fatal(err)
	}
	return MyHandler{conn: conn}
}

func (this MyHandler) HandleQuery(query string) (*mysql.Result, error) {
	stmt, err := Parse(query)
	if err != nil {
		return nil, err
	}
	switch stmt := stmt.(type) {
	case *Select: //目前我们只支持 select的基本功能
		sqls := AliasedTableSQl(stmt)
		if len(sqls) > 0 { //代表有拆分SQL
			results := make([]*mysql.Result, 0)
			for _, sql := range sqls {
				r, err := this.conn.Execute(sql)
				if err != nil {
					return nil, err
				}
				results = append(results, r)
			}
			if len(results) > 1 {
				for index, result := range results {
					if index == 0 {
						continue
					}
					results[0].RowDatas = append(results[0].RowDatas, result.RowDatas...)
					results[0].AffectedRows += result.AffectedRows
				}
				return results[0], nil
			} else {
				return results[0], nil
			}

		} else {
			return this.conn.Execute(query)
		}
	default:
		return this.conn.Execute(query)
	}

}
