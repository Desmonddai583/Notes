package main

import (
	"net"

	_ "github.com/siddontang/go-mysql/driver"
	"github.com/siddontang/go-mysql/server"
	"gomysql.jtthink.com/util"
)

func main() {
	l, _ := net.Listen("tcp", "0.0.0.0:3309")
	for {
		c, _ := l.Accept()
		go (func() {
			conn, _ := server.NewConn(c, "root", "123", util.NewMyHandler())
			for {
				conn.HandleCommand()
			}
		})()
	}

}
