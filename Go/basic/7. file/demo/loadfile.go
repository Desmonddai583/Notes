package main

import (
	"bufio"
	"bytes"
	"fmt"
	"log"
	"strings"
)
func dropCR(data []byte) []byte {
	if len(data) > 0 && data[len(data)-1] == ':' {
		return data[0 : len(data)-1]
	}
	return data
}
func split(data []byte, atEOF bool) (advance int, token []byte, err error) {
	if atEOF && len(data) == 0 {
		return 0, nil, nil
	}
	if i := bytes.IndexByte(data, ':'); i >= 0 {
		// We have a full newline-terminated line.
		return i + 1, dropCR(data[0:i]), nil
	}
	// If we're at EOF, we have a final, non-terminated line. Return it.
	if atEOF {
		return len(data), dropCR(data), nil
	}
	// Request more data.
	return 0, nil, nil
}
func main()  {
	reader:=strings.NewReader("aaa:bbb:ccc:ddd:eee:fff:ggg")
	scanner:=bufio.NewScanner(reader)
    scanner.Split(split)
	count:=0
	for scanner.Scan(){
		log.Println(scanner.Text())
		count++
	}
	fmt.Println("一共有",count,"行")


}