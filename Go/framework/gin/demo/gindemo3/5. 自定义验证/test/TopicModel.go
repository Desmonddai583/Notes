package test

type Topic struct { //验证器
	TopicID         int    `json:"id"`
	TopicTitle      string `json:"title" binding:"min=4,max=20"`
	TopicShortTitle string `json:"shorttitle" binding:"required,nefield=TopicTitle"`
	UserIP          string `json:"ip" binding:"ipv4"`
	TopicScore      int    `json:"score" binding:"omitempty,gt=5"`        // 可以不填填了必须大于5
	TopicUrl        string `json:"topicurl" binding:"omitempty,topicurl"` // 自定义验证器topicurl
}

type Topics struct {
	TopicList []Topic `json:"topics" binding:"gt=1,max=4,dive"` //gt也可以校验数组的长度
	//TopicList []Topic `json:"topics" binding:"gt=0,lt=3"` //gt也可以校验数组的长度
	TopicSize int `json:"size" binding:"topicsize"`
}

func CreateTopic(id int, title string) Topic {
	return Topic{TopicID: id, TopicTitle: title}
}

type TopicQuery struct {
	Username string `json:"username" form:"username"` //form将query查询映射到struct中
	Page     int    `json:"page" form:"page" binding:"required"`
	PageSize int    `json:"pagesize" form:"pagesize"`
}

type TopicClass struct {
	ClassId     int
	ClassName   string
	ClassRemark string
	ClassType   string `gorm:"column:classType"` //gorm默认规则是驼峰中间下划线，我们可以指定字段名
}
