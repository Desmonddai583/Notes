package main

import (
	"flag"
	"goraft/src/configsvr"
	"goraft/src/lib"
	"log"
)

func main() {
	cfile := ""
	flag.StringVar(&cfile, "c", "", "your config file ")
	flag.Parse()
	if cfile == "" {
		log.Fatal("config file error")
	}
	err := lib.BootStrap(cfile)
	if err != nil {
		log.Fatal(err)
	}
	//测试插入 配置
	//set:=configsvr.NewConfigSet("test","test content")
	//config:=configsvr.NewConfigService("default","mysql","v1",set)
	//err=config.Save()
	//if err!=nil{
	//	log.Fatal(err)
	//}
	//启动gin
	//lib.CacheServer().Run(":"+lib.SysConfig.Port)
	configsvr.ConfigHttp().Run(":" + lib.SysConfig.Port)

}
