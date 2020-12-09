package goft

import (
	"log"
	"xorm.io/xorm"
	_ "github.com/go-sql-driver/mysql"
)

type XOrmAdapter struct {
	*xorm.Engine
}
func(this *XOrmAdapter) Name() string{
	return "XOrmAdapter"
}
func NewXOrmAdapter() *XOrmAdapter {
	engine, err := xorm.NewEngine("mysql",
		"root:123123@tcp(localhost:3307)/test?charset=utf8mb4&parseTime=True&loc=Local")
	if err!=nil{
		log.Fatal(err)
	}
	engine.DB().SetMaxIdleConns(5)
	engine.DB().SetMaxOpenConns(10)
	return &XOrmAdapter{Engine:engine}
}