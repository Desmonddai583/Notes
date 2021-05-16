package lib

import (
	"fmt"
	"io/ioutil"
	"log"

	"github.com/go-yaml/yaml"
	"github.com/hashicorp/raft"
)

type Server struct {
	ID      raft.ServerID
	Address raft.ServerAddress
	Http    string
}

type Config struct {
	ServerName  string `yaml:"server-name"`
	ServerID    string `yaml:"server-id"`
	LogStore    string
	StableStore string
	Snapshot    string //快照保存的位置
	Transport   string
	Servers     []Server
	Port        string
	LocalCache  string `yaml:"local-cache"`
}

func NewConfig() *Config {
	return &Config{}
}
func loadConfigFile(path string) []byte {
	b, err := ioutil.ReadFile(path)
	if err != nil {
		log.Println(err)
		return nil
	}
	return b
}
func LoadConfig(path string) (*Config, error) {
	config := NewConfig()
	if b := loadConfigFile(path); b != nil {
		err := yaml.Unmarshal(b, config)
		if err != nil {
			return nil, err
		}
		return config, err
	} else {
		return nil, fmt.Errorf("加载配置失败")
	}

}
