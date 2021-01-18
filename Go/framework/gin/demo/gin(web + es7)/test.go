package main

import (
	"context"

	"es.jtthink.com/AppInit"
	"es.jtthink.com/logparser"

	"log"

	"github.com/olivere/elastic/v7"
)

func main() {
	p := logparser.NewHttpdParser("./logs/apache_log.txt")
	list := p.Parse()
	client := AppInit.GetEsClient()
	bulk := client.Bulk()
	for _, m := range list {
		req := elastic.NewBulkIndexRequest()
		req.Index("bookslogs").Doc(m) //直接插入
		bulk.Add(req)
	}
	_, err := bulk.Do(context.Background())
	if err != nil {
		log.Println(err)
	}
}
