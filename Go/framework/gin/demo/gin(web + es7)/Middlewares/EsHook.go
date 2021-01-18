package Middlewares

import (
	"context"
	"log"
	"strings"

	"es.jtthink.com/AppInit"
	"github.com/olivere/elastic/v7"
	"github.com/sirupsen/logrus"
)

type EsHook struct {
}

func NewEsHook() *EsHook {
	return &EsHook{}
}
func (this *EsHook) Fire(entry *logrus.Entry) error {
	data := entry.Data
	data["time"] = entry.Time
	data["level"] = entry.Level
	data["msg"] = entry.Message
	if strings.Index(data["url"].(string), "/favicon.ico") >= 0 {
		return nil
	}
	client := AppInit.GetEsClient()
	bulk := client.Bulk()
	{
		req := elastic.NewBulkIndexRequest()
		req.Index("bookslogs").Doc(data) //直接插入
		bulk.Add(req)
	}
	_, err := bulk.Do(context.Background())
	if err != nil {
		log.Println(err)
	}
	return nil
}
func (this *EsHook) Levels() []logrus.Level {
	return logrus.AllLevels
}
