package lib

import (
	"log"

	"github.com/hashicorp/raft"
)

type MySnapshot struct{}

func NewMySnapshot() *MySnapshot {
	return &MySnapshot{}
}
func (this *MySnapshot) Persist(sink raft.SnapshotSink) error {
	//b,err:=json.Marshal(getCache()) //写json 快照
	//if err!=nil{
	//	return err
	//}else{
	// _,err:= sink.Write(b)
	// if err!=nil{
	// 	log.Println("snapshot write error",err)
	// 	return sink.Cancel()
	// }
	//}
	return nil
}

func (this *MySnapshot) Release() {
	log.Println("快照生成完成")
}
