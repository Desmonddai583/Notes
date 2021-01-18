package main

import (
	"context"
	"fmt"
	"log"

	"github.com/olivere/elastic"
)

func main() {

	client, err := elastic.NewClient(
		elastic.SetURL("http://192.168.29.135:9200/"),
		elastic.SetSniff(false),
	)
	if err != nil {
		log.Fatal(err)
	}
	ctx := context.Background()
	mapping, err := client.GetMapping().Index("news").Do(ctx)
	if err != nil {
		log.Fatal(err)
	}
	fmt.Println(mapping)

	json := `{"news_title":"test1","news_type":"php","news_status":1}`
	data, err := client.Index().Index("news").
		Id("101").BodyString(json).Do(ctx)
	if err != nil {
		log.Fatal(err)
	}
	fmt.Println(data)
}
