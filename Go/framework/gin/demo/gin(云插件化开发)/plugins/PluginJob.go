package plugins

import (
	"context"
	"fmt"
	"log"
	"os"

	"github.com/go-git/go-git/v5"
	"github.com/google/go-github/github"
)

var client *github.Client
var lock = false //简单的锁，防止 同时执行
func init() {
	client = github.NewClient(nil)
}
func FileExist(path string) bool {
	_, err := os.Lstat(path)
	return !os.IsNotExist(err)
}

// /xx/xxx/xx
func CloneRepo(path string, url string, id int64) {
	err := os.MkdirAll(path, 0666)
	if err != nil {
		panic(err)
	}
	err = os.RemoveAll(path + "/") //清空 文件内容
	if err != nil {
		panic(err)
	}
	_, err = git.PlainClone(path, false, &git.CloneOptions{
		URL:      url,
		Progress: os.Stdout,
	})
	if err != nil {
		panic(err)
	}
	configPath := path + "/.jtthink.yaml"
	if FileExist(configPath) {
		cfg, err := LoadConfig(configPath)
		if err != nil {
			panic(err)
		}
		err = LoadPlugin(cfg, id)
		if err != nil {
			panic(err)
		}
	} else {
		panic("error config file")
	}
}
func StartJob() {
	defer func() {
		if e := recover(); e != nil {
			log.Println("插件任务出错：", e)
		}
		lock = false
	}()
	if lock {
		return
	}
	lock = true
	reps, _, err := client.Search.Repositories(
		context.Background(),
		"topic:jtthink-plugin",
		nil,
	)
	if err != nil {
		panic(err)
	}
	for _, rep := range reps.Repositories {
		//下载仓库代码，并解析，塞入 pluginlist
		CloneRepo(fmt.Sprintf("./repos/%d/src/github.com/%s/%s",
			rep.GetID(), rep.GetOwner().GetLogin(), rep.GetName(),
		), rep.GetCloneURL(), rep.GetID())
	}
}
