package lib

import (
	"log"
	"time"
)

type NewsModel struct {
	NewsID      int       `gorm:"column:id" json:"id"`
	NewsTitle   string    `gorm:"column:newstitle" json:"title"`
	NewsContent string    `gorm:"column:newscontent" json:"content"`
	NewsViews   int       `gorm:"column:views" json:"views"`
	NewsTime    time.Time `gorm:"column:addtime" json:"addtime"`
}

func NewNewsModel() *NewsModel {
	return &NewsModel{}
}
func (this *NewsModel) Test() {
	log.Println("data from NewsModel")
}
