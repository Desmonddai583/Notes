package main

import (
	"goraft/src/lib"
	"log"
	"net"
	"os"
	"strings"
	"time"

	"github.com/hashicorp/go-hclog"
	"github.com/hashicorp/raft"
	"github.com/hashicorp/raft-boltdb"
)

func main() {

	//节点配置
	config := raft.DefaultConfig()
	config.LocalID = "1"
	config.Logger = hclog.New(&hclog.LoggerOptions{
		Name:   "myraft-1",
		Level:  hclog.LevelFromString("DEBUG"),
		Output: os.Stderr,
	})

	//logStore保存配置
	dir, _ := os.Getwd()
	root := strings.Replace(dir, "\\", "/", -1)
	log_store, err := raftboltdb.NewBoltStore(root + "/n1/log_store.bolt")
	if err != nil {
		log.Fatal(err)
	}
	//保存节点信息
	stable_store, err := raftboltdb.NewBoltStore(root + "/n1/stable_store.bolt")
	if err != nil {
		log.Fatal(err)
	}
	//不存储快照
	snapshotStore := raft.NewDiscardSnapshotStore()

	// 节点之间的通信
	addr, err := net.ResolveTCPAddr("tcp", "127.0.0.1:3000")
	transport, err := raft.NewTCPTransport(addr.String(), addr, 5, time.Second*10, os.Stdout)
	if err != nil {
		log.Fatal(err)
	}
	fsm := &lib.MyFSM{}

	node, err := raft.NewRaft(config, fsm, log_store, stable_store, snapshotStore, transport)
	configuration := raft.Configuration{
		Servers: []raft.Server{
			{
				ID:      config.LocalID,
				Address: transport.LocalAddr(),
			},
		},
	}

	node.BootstrapCluster(configuration)

}
