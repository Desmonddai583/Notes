package config

import (
	"gorm.io/driver/mysql"
	"gorm.io/gorm"

	"log"
	"time"
)

type DbConfig struct {
}

// 本课程来自 程序员在囧途(www.jtthink.com ) 咨询群：98514334
func NewDbConfig() *DbConfig {
	return &DbConfig{}
}

// 本课程来自 程序员在囧途(www.jtthink.com ) 咨询群：98514334
func (dbc *DbConfig) InitDB() *gorm.DB {
	dsn := "root:123456@tcp(mydb:3306)/rustdb?charset=utf8mb4&parseTime=True&loc=Local"
	gormdb, err := gorm.Open(mysql.Open(dsn), &gorm.Config{})
	if err != nil {
		log.Fatalln(err)
	}
	db, err := gormdb.DB()
	if err != nil {
		log.Fatalln(err)
	}
	db.SetConnMaxLifetime(time.Minute * 10)
	db.SetMaxIdleConns(10)
	db.SetMaxOpenConns(20)

	return gormdb
}
