package plugins

import (
	"fmt"
	"io/ioutil"
	"net/http"
	"os"
	"sync"

	"github.com/traefik/yaegi/interp"
	"github.com/traefik/yaegi/stdlib"
	"gopkg.in/yaml.v2"
)

type PluginConfig struct {
	Name    string
	Import  string
	Package string
	Summary string
	Version string //增加版本字段
}
type PluginModel struct {
	cfg   *PluginConfig
	value http.Handler
}

func (this *PluginModel) GetHandler() http.Handler {
	return this.value
}
func NewPluginModel(cfg *PluginConfig, value http.Handler) *PluginModel {
	return &PluginModel{cfg: cfg, value: value}
}

//这里做了修改
var PluginList sync.Map //插件列表   [name]==> PluginModel
//加载插件
func LoadPlugin(cfg *PluginConfig, id int64) error {
	i := interp.New(interp.Options{GoPath: fmt.Sprintf("./repos/%d/", id)})
	i.Use(stdlib.Symbols)
	if _, err := i.Eval(fmt.Sprintf(`import "%s"`, cfg.Import)); err != nil {
		return err
	}
	obj, err := i.Eval(cfg.Package + `.New()`)
	if err != nil {
		return err
	}
	key := fmt.Sprintf("%s", cfg.Name)
	if v, ok := PluginList.Load(key); ok {
		if v.(*PluginModel).cfg.Version != cfg.Version {
			PluginList.Store(key, NewPluginModel(cfg, obj.Interface().(http.Handler)))
		}
	} else {
		PluginList.Store(key, NewPluginModel(cfg, obj.Interface().(http.Handler)))
	}

	return nil
}

//加载插件配置
func LoadConfig(path string) (*PluginConfig, error) {
	f, err := os.Open(path)
	defer f.Close() //这里必须关闭
	if err != nil {
		return nil, err
	}
	b, err := ioutil.ReadAll(f)
	if err != nil {
		return nil, err
	}
	config := &PluginConfig{}

	err = yaml.Unmarshal(b, config)
	if err != nil {
		return nil, err
	}
	if config.Version == "" || config.Import == "" || config.Package == "" {
		return nil, fmt.Errorf("error config params")
	}
	return config, nil

}
