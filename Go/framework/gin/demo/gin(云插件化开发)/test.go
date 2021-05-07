package main

import (
	"context"
	"fmt"
	"ginplugin/plugins"
	"log"
	"os"

	"github.com/go-git/go-git/v5"
	"github.com/google/go-github/github"
)

func FileExist(path string) bool {
	_, err := os.Lstat(path)
	return !os.IsNotExist(err)
}

// /xx/xxx/xx
func CloneRepo(path string, url string, id int64) {
	err := os.MkdirAll(path, 0666)
	if err != nil {
		log.Fatal(err)
	}
	err = os.RemoveAll(path + "/") //清空 文件内容
	if err != nil {
		log.Fatal(err)
	}
	_, err = git.PlainClone(path, false, &git.CloneOptions{
		URL:      url,
		Progress: os.Stdout,
	})
	if err != nil {
		log.Fatal(err)
	}
	configPath := path + "/.jtthink.yaml"
	if FileExist(configPath) {
		cfg, err := plugins.LoadConfig(configPath)
		if err != nil {
			log.Fatal(err)
		}
		err = plugins.LoadPlugin(cfg, id)
		if err != nil {
			log.Fatal(err)
		}
	} else {
		log.Fatal("error config file")
	}
}
func main() {
	client := github.NewClient(nil)
	reps, _, err := client.Search.Repositories(
		context.Background(),
		"topic:jtthink-plugin",
		nil,
	)
	if err != nil {
		log.Fatal(err)
	}

	for _, rep := range reps.Repositories {
		//下载仓库代码，并解析，塞入 pluginlist
		CloneRepo(fmt.Sprintf("./repos/%d/src/github.com/%s/%s",
			rep.GetID(), rep.GetOwner().GetLogin(), rep.GetName(),
		), rep.GetCloneURL(), rep.GetID())
	}
	plugins.PluginList.Range(func(key, value interface{}) bool {
		fmt.Println(key)
		return true
	})

}
