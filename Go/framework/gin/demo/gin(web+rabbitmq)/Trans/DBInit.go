package Trans

import (
	_ "github.com/go-sql-driver/mysql"
	"github.com/jmoiron/sqlx"
)

var db *sqlx.DB

func DBInit(dbName string) error {
	var err error
	db, err = sqlx.Connect("mysql",
		"root:123123@tcp(localhost:3307)/"+dbName+"?charset=utf8mb4&parseTime=True&loc=Local")
	if err != nil {
		return err
	}
	db.SetMaxOpenConns(20)
	db.SetMaxIdleConns(10)
	return nil
}
func GetDB() *sqlx.DB {
	return db
}
