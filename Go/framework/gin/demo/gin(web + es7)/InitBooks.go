package main

import (
	"context"
	"fmt"
	"log"
	"strconv"
	"sync"

	"es.jtthink.com/AppInit"
	"es.jtthink.com/Models"
	"github.com/olivere/elastic/v7"
)

func main() {
	page := 1
	pagesize := 500
	wg := sync.WaitGroup{}
	for {
		book_list := Models.BookList{}
		db := AppInit.GetDB().Select("book_id,book_name,book_intr,book_price1,book_price2,book_author,book_press,book_kind " +
			",if(book_date='','1970-01-01',ltrim(book_date)) as book_date").
			Order("book_id desc").Limit(pagesize).Offset((page - 1) * pagesize).Find(&book_list)
		if db.Error != nil || len(book_list) == 0 {
			break
		}
		wg.Add(1)
		go func() {
			defer wg.Done()
			client := AppInit.GetEsClient()
			bulk := client.Bulk()
			for _, book := range book_list {
				req := elastic.NewBulkIndexRequest()
				req.Index("books").Id(strconv.Itoa(book.BookID)).Doc(book)
				bulk.Add(req)
			}
			rsp, err := bulk.Do(context.Background())
			if err != nil {
				log.Println(err)
			} else {
				fmt.Println(rsp)
			}
		}()
		page = page + 1 //必须有
	}
	wg.Wait()

}
