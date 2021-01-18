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
		"root:123123@tcp(localhost:3307)/myjava?charset=utf8mb4&parseTime=True&loc=Local")
	if err != nil {
		log.Fatal(err)
	}
	db.SingularTable(true)
	db.DB().SetMaxIdleConns(5)
	db.DB().SetMaxOpenConns(10)

}

func GetDB() *gorm.DB {
	return db
}
