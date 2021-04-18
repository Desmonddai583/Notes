package AppInit

import (
	"log"

	"github.com/jinzhu/gorm"
	_ "github.com/jinzhu/gorm/dialects/mysql"
)

var db *gorm.DB

func init() {
	var err error
	db, err = gorm.Open("mysql",
		"root:123123@tcp(localhost:3307)/swoft2?charset=utf8mb4&parseTime=True&loc=Local")
	if err != nil {
		log.Fatal(err)
	}
	db.SingularTable(true)
	db.DB().Ping()
	db.DB().SetMaxIdleConns(10)
	db.DB().SetMaxOpenConns(20)

	// db.LogMode(true)
}
func GetDB() *gorm.DB {
	return db
}
