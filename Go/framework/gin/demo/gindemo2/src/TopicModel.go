package src

import "time"

type Topics struct { //单个Topic实体
	TopicID int `json:"id" gorm:"PRIMARY_KEY"`
	TopicTitle string `json:"title" binding:"min=4,max=20"`
	TopicShortTitle string `json:"stitle" binding:"required,nefield=TopicTitle"`
	UserIp string `json:"ip" binding:"ipv4"`
	TopicScore int `json:"score" binding:"omitempty,gt=5"`
	TopicUrl string `json:"url" binding:"omitempty,topicurl"`
	TopicDate time.Time `json:"url" binding:"required"`

}
type TopicArray struct {
	TopicList []Topics `json:"topics" binding:"gt=0,lt=3,topics,dive"`
	TopicListSize int `json:"size"`
}

func CreateTopic(id int ,title string) Topics  {
	return Topics{TopicID:id,TopicTitle:title}
}
//topic_classes
type TopicClass struct {
	ClassId int `gorm:"PRIMARY_KEY"`
	ClassName string
	ClassRemark string
	ClassType string `gorm:"Column:classtype"`
}


type TopicQuery struct {
	UserName string `json:"username" form:"username"`
	Page int `json:"page" form:"page" binding:"required"`
	PageSize int `json:"pagesize" form:"pagesize"`

}
