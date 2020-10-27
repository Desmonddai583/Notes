package mock

import "fmt"

// Retriever 定義Retriever結構
type Retriever struct {
	Contents string
}

// 實現stringer接口，類似其他語言中的to_string方法
func (r *Retriever) String() string {
	return fmt.Sprintf(
		"Retriever: {Contents=%s}", r.Contents)
}

// Post 實現Post方法
func (r *Retriever) Post(url string,
	form map[string]string) string {
	r.Contents = form["contents"]
	return "ok"
}

// Get 實現Get方法
func (r *Retriever) Get(url string) string {
	return r.Contents
}
