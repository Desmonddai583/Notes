package main

import (
	"log"
	"sync"

	"github.com/gin-gonic/gin"
	"github.com/jinzhu/gorm"
	_ "github.com/jinzhu/gorm/dialects/mysql"
)

type Book struct {
	BookId   int    `gorm:"column:book_id;AUTO_INCREMENT;PRIMARY_KEY"`
	BookName string `gorm:"column:book_name;type:varchar(50)" json:"book_name,omitempty"`
}

var db *gorm.DB
var dbonce sync.Once

func getDB() *gorm.DB {
	dbonce.Do(func() {
		var err error
		db, err = gorm.Open("mysql",
			"root:123123@tcp(localhost:3307)/myjava?charset=utf8mb4&parseTime=True&loc=Local")
		if err != nil {
			log.Fatal(err)
		}
		db.SingularTable(true)
		db.DB().SetMaxIdleConns(5)
		db.DB().SetMaxOpenConns(10)
	})
	return db
}
func main() {
	r := gin.New()
	r.Handle("GET", "/", func(context *gin.Context) {
		context.JSON(200, gin.H{"message": "index"})
	})
	r.Handle("GET", "/prods", func(context *gin.Context) {
		books := []Book{}
		getDB().Table("books").Order("book_id desc ").Limit(10).Find(&books)
		context.JSON(200, books)
	})
	r.Run(":8080")

}
