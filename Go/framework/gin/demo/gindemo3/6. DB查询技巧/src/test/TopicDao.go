package test

import (
	"github.com/gin-gonic/gin"
	"strconv"
)


func GetTopicDetail(c *gin.Context) { //业务层只做业务层的事情，数据库查询再这里做
	tid := c.Param("topic_id")
	id, _ := strconv.Atoi(tid)
	topic := Topic{TopicID: id}

	c.Set("dbResult", topic)
}

func GetTopicList(c *gin.Context) {
	query := Topic{}
	err := c.BindQuery(&query)
	if err != nil {
		c.String(400, "参数错误%s", err.Error())
	} else {
		c.JSON(200, query)
	}

}

func NewTopic(c *gin.Context) {
	topics := Topics{}
	err := c.BindJSON(&topics)
	if err != nil {
		c.String(400, "参数错误%s", err.Error())
	} else {
		c.JSON(200, topics)
	}
}

func DelTopic(c *gin.Context) {
	c.String(200, "删除帖子")
}
