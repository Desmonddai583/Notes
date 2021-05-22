package main

import (
	"context"
	"fmt"
	"log"
	"reflect"

	"github.com/olivere/elastic/v7"
)

type Books struct {
	BookID     int
	BookName   string
	BookPrice1 float64
	BookAuthor string
}

func MapToBooks(rsp *elastic.SearchResult) []*Books {
	ret := []*Books{}
	var t *Books
	for _, item := range rsp.Each(reflect.TypeOf(t)) {
		ret = append(ret, item.(*Books))
	}
	return ret
}
func getClient() *elastic.Client {
	client, err := elastic.NewSimpleClient(
		elastic.SetSniff(false),
		elastic.SetURL("http://es.jtthink.com/es1/", "http://es.jtthink.com/es2/"),
	)
	if err != nil {
		panic(err)
	}
	return client
}
func main() {

	matchQuery := elastic.NewMatchQuery("BookName", "我从小就喜欢java编程")
	rsp, err := getClient().Search().Index("books").Query(matchQuery).Do(context.Background())
	if err != nil {
		log.Fatal(err)
	}
	books := MapToBooks(rsp)
	for _, book := range books {
		fmt.Println(book)
	}

}
