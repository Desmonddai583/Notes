package util

import (
	"github.com/go-ini/ini"
	"log"
	"os"
)

var ProxyConfigs map[string]string
type EnvConfig *os.File

func init()  {
	ProxyConfigs=make(map[string]string)
	EnvConfig,err:= ini.Load("env")
	if err!=nil{
		log.Println(err)
		return
	}
	proxy,_:=EnvConfig.GetSection("proxy") //假设是固定的 分区
	if proxy!=nil{
		secs:=proxy.ChildSections() //获取子分区
		for _,sec:=range secs{
			path,_:= sec.GetKey("path") //固定Key
			pass,_:= sec.GetKey("pass")//固定Key
			if path!=nil && pass !=nil{
				ProxyConfigs[path.Value()]=pass.Value()
			}
		}
	}


}
