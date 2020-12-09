package src

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

func MustLogin() gin.HandlerFunc { //必须登录
	return func(c *gin.Context) {
		if _, status := c.GetQuery("token"); !status {
			c.String(http.StatusUnauthorized, "缺少token参数")
			c.Abort()
		} else {
			c.Next()
		}
	}
}

func GetTopicDetail(c *gin.Context) {
	tid := c.Param("topic_id")
	topics := Topics{}
	DBHelper.Find(&topics, tid) //从数据库取
	c.Set("dbResult", topics)
	// 强制指定表名
	// db.Table("test").First(&test)
	// 可以使用db.SingularTable(true) 来 使其不加复数
}
func NewTopic(c *gin.Context) { //单帖子新增
	topic := Topics{}
	err := c.BindJSON(&topic)
	if err != nil {
		c.String(400, "参数错误:%s", err.Error())
	} else {
		c.JSON(200, topic)
	}
}
func NewTopics(c *gin.Context) { //多帖子批量新增
	topics := TopicArray{}
	err := c.BindJSON(&topics)
	if err != nil {
		c.String(400, "参数错误:%s", err.Error())
	} else {
		c.JSON(200, topics)
	}
}

func DelTopic(c *gin.Context) {
	//判断登录
	c.String(200, "删除帖子")
}
func GetTopicList(c *gin.Context) {
	query := TopicQuery{}
	err := c.BindQuery(&query)
	if err != nil {
		c.String(400, "参数错误:%s", err.Error())
	} else {
		c.JSON(200, query)
	}
}
