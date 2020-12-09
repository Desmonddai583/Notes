package models

import "time"

type ArticleModel struct {
	NewsId int `json:"id" gorm:"column:id" uri:"id" binding:"required,gt=0"`
	NewsTitle string `json:"title" gorm:"column:newstitle"`
	NewsContent string `json:"content" gorm:"column:newscontent"`
	Views int `json:"views" gorm:"column:views"`
	Addtime time.Time `json:"addtime" gorm:"column:addtime"`
}
func NewArticleModel() *ArticleModel {
	return &ArticleModel{}
}
func(this *ArticleModel) String() string   {
	return "ArticleModel"
}
