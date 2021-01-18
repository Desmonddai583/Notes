package logparser

import (
	"bufio"
	"bytes"
	"context"
	"log"
	"os"
	"regexp"

	"es.jtthink.com/AppInit"
	"github.com/olivere/elastic/v7"
)

//根据分组名 把键值映射到Map中
func MapGroup(list []string, names []string) map[string]interface{} {
	ret := make(map[string]interface{})

	if len(list) <= 1 {
		return nil
	}
	for index, name := range names {
		if index == 0 || name == "" {
			continue
		}
		ret[name] = list[index]
	}
	return ret
}

type HttpdParser struct {
	Regex *regexp.Regexp
}

func NewHttpdParser() *HttpdParser {
	var buffer bytes.Buffer
	buffer.WriteString(`^(?P<ip>\d+.\d+.\d+.\d+).*?`)              // ip
	buffer.WriteString(`\[(?P<time>.+?)\]\s*`)                     //time
	buffer.WriteString(`\"(?P<method>[A-Z]+)\s*(?P<url>.*?)\"\s*`) //method和URL
	buffer.WriteString(`(?P<status>\d+)\s*`)                       //status
	buffer.WriteString(`(?P<duration>\d+)\s*`)                     //duration
	buffer.WriteString(`\"(?P<referer>.*?)\"\s*`)                  //referer
	buffer.WriteString(`\"(?P<agent>.*?)\"\s*`)                    //agent
	return &HttpdParser{Regex: regexp.MustCompile(buffer.String())}

}
func (this *HttpdParser) ParseToEs(filename string) {
	file, err := os.Open(filename)
	if err != nil {
		log.Fatal("logfile error:", err)
	}
	client := AppInit.GetEsClient()
	bulk := client.Bulk()
	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		result := this.Regex.FindStringSubmatch(scanner.Text())
		m := MapGroup(result, this.Regex.SubexpNames())
		req := elastic.NewBulkIndexRequest()
		req.Index("bookslogs").Doc(m)
		bulk.Add(req)
	}
	_, err = bulk.Do(context.Background())
	if err != nil {
		log.Println(err)
	}

}
