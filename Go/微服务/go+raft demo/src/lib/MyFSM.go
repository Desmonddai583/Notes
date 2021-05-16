package lib

import (
	"encoding/json"
	"io"
	"log"

	"github.com/hashicorp/raft"
)

type MyFSM struct {
}

//真正 持久化数据
func (this *MyFSM) Apply(log *raft.Log) interface{} {
	req := NewCacheRequest()
	err := json.Unmarshal(log.Data, req)
	Set(req.Key, req.Value) //真正执行  数据保存
	return err
}
func (this *MyFSM) Snapshot() (snapshot raft.FSMSnapshot, err error) {
	return NewMySnapshot(), nil

}
func (this *MyFSM) Restore(reader io.ReadCloser) error {
	err := json.NewDecoder(reader).Decode(getCache())
	if err != nil {
		log.Println("restore error:", err)
		return err
	}
	return nil
}
