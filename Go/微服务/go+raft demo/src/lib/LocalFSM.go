package lib

import (
	"encoding/json"
	"io"

	"github.com/hashicorp/raft"
)

type LocalFSM struct {
}

//真正 持久化数据
func (this *LocalFSM) Apply(log *raft.Log) interface{} {
	req := NewCacheRequest()
	err := json.Unmarshal(log.Data, req)
	if err != nil {
		return err
	}
	return LocalCache.SetItem(req.Key, req.Value)

}
func (this *LocalFSM) Snapshot() (snapshot raft.FSMSnapshot, err error) {
	return nil, nil

}
func (this *LocalFSM) Restore(reader io.ReadCloser) error {

	return nil
}
