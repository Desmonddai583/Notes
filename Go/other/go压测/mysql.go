package main

import (
	"log"
	"sync"
	"time"

	_ "github.com/go-sql-driver/mysql"
	"github.com/jinzhu/gorm"
	"github.com/myzhan/boomer"
)

type BookModel struct {
	BookId   int    `gorm:"column:book_id;AUTO_INCREMENT;PRIMARY_KEY"`
	BookName string `gorm:"column:book_name;type:varchar(50)" json:"book_name,omitempty"`
}

var mysqldb *gorm.DB
var mysqldbonce sync.Once

func getMysqlDB() *gorm.DB {
	mysqldbonce.Do(func() {
		var err error
		mysqldb, err = gorm.Open("mysql",
			"root:123123@tcp(localhost:3307)/myjava?charset=utf8mb4&parseTime=True&loc=Local")
		if err != nil {
			log.Fatal(err)
		}
		mysqldb.SingularTable(true)
		mysqldb.DB().SetMaxIdleConns(20)
		mysqldb.DB().SetMaxOpenConns(100)
	})
	return mysqldb
}

func execSql(name string, sql string) {
	start := time.Now()
	books := []*BookModel{}
	db := getMysqlDB().Raw(sql).Find(&books)
	end := time.Since(start)
	if db.Error != nil {
		boomer.RecordFailure("mysql", name, end.Nanoseconds()/int64(time.Millisecond),
			db.Error.Error())
	} else {
		boomer.RecordSuccess("mysql", name,
			end.Nanoseconds()/int64(time.Millisecond), db.RowsAffected)
	}
}

func main() {
	sql1 := &boomer.Task{
		Name:   "sql1",
		Weight: 5,
		Fn: func() {
			execSql("sql1", "select * from books limit 5000")
		},
	}
	sql2 := &boomer.Task{
		Name:   "sql2",
		Weight: 5,
		Fn: func() {
			execSql("sql2", "select * from books order by book_id desc limit 5000")
		},
	}

	boomer.Run(sql1, sql2)
}
