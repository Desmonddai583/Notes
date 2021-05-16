package lib

import (
	"fmt"
	"log"
	"net"
	"os"
	"strings"
	"time"

	"github.com/hashicorp/go-hclog"
	"github.com/hashicorp/raft"
	"github.com/hashicorp/raft-boltdb"
)

var RaftNode *raft.Raft
var SysConfig *Config

func BootStrap(path string) error {
	c, err := LoadConfig(path)
	if err != nil {
		return err
	}
	SysConfig = c

	config := raft.DefaultConfig()
	config.LocalID = raft.ServerID(SysConfig.ServerID)
	config.Logger = hclog.New(&hclog.LoggerOptions{
		Name:   SysConfig.ServerName,
		Level:  hclog.LevelFromString("DEBUG"),
		Output: os.Stderr,
	})
	//config.SnapshotInterval=time.Second*5
	//config.SnapshotThreshold=2

	setLocalPath(SysConfig.LocalCache)
	initLocalCache() //初始化本地KV

	//logStore保存配置
	dir, _ := os.Getwd()
	root := strings.Replace(dir, "\\", "/", -1)
	log_store, err := raftboltdb.NewBoltStore(root + SysConfig.LogStore)
	if err != nil {
		return err
	}

	//保存节点信息
	stable_store, err := raftboltdb.NewBoltStore(root + SysConfig.StableStore)
	if err != nil {
		return err
	}
	//保存 文件快照
	//snapshotStore,err:= raft.NewFileSnapshotStore(root+SysConfig.Snapshot,1,nil)
	//if err!=nil{
	//	return err
	//}
	snapshotStore := raft.NewDiscardSnapshotStore()

	// 节点之间的通信
	addr, err := net.ResolveTCPAddr("tcp", SysConfig.Transport)
	transport, err := raft.NewTCPTransport(addr.String(), addr, 5, time.Second*10, os.Stdout)
	if err != nil {
		log.Fatal(err)
	}
	//fsm:=&MyFSM{}
	fsm := &LocalFSM{}

	RaftNode, err = raft.NewRaft(config, fsm, log_store, stable_store, snapshotStore, transport)
	if err != nil {
		return err
	}
	servers := []raft.Server{} //改动点， 循环构建
	for _, s := range SysConfig.Servers {
		servers = append(servers, raft.Server{ID: s.ID, Address: s.Address})
	}
	fmt.Println(SysConfig.Servers)
	configuration := raft.Configuration{
		Servers: servers,
	}
	RaftNode.BootstrapCluster(configuration)
	return nil
}
