package lib

import (
	"log"

	"github.com/shenyisyn/goft-redis/gedis"
)

func NewsDBGetter(id string) gedis.DBGetterFunc {
	return func() interface{} {
		log.Println("get from db")
		newsModel := NewNewsModel()
		//Gorm.Table("mynews").Where("id=?",id).Find(newsModel)
		//return newsModel
		if Gorm.Table("mynews").
			Where("id=?", id).Find(newsModel).Error != nil || newsModel.NewsID <= 0 {
			return nil
		}
		return newsModel
	}

}
