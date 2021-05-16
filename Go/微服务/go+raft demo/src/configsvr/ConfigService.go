package configsvr

import (
	"crypto/md5"
	"fmt"
	"goraft/src/lib"
	"log"
	"strings"

	"github.com/golang/protobuf/proto"
)

//配置对应的value
//type ConfigSet struct {
//	Desc string
//	Md5 string //自动生成
//	Content string
//}
func NewConfigSet(desc string, content string) *ConfigSet {
	b := md5.Sum([]byte(content))
	return &ConfigSet{Desc: desc, Content: content, Md5: fmt.Sprintf("%x", b)}
}

//包含了 key 和value
type ConfigService struct {
	Group   string     `json:"group"`
	DataId  string     `json:"dataId"`
	Version string     `json:"version"`
	Config  *ConfigSet `json:"-"`
}

func NewConfigService(group string, dataId string, version string, config *ConfigSet) *ConfigService {
	if config == nil {
		config = &ConfigSet{}
	}
	return &ConfigService{Group: group, DataId: dataId, Version: version, Config: config}
}
func (this *ConfigService) Key() []byte {
	return []byte(fmt.Sprintf("/%s/%s/%s", this.Group, this.DataId, this.Version))
}

//保存到本地kv
func (this *ConfigService) Save() error {
	b, err := proto.Marshal(this.Config) //统一protobuf序列化
	if err != nil {
		return err
	}
	return lib.LocalCache.SetItemWithBytes(this.Key(), b)
}

//加载配置
func (this *ConfigService) Load() error {
	b, err := lib.LocalCache.GetItem(this.Key())
	if err != nil {
		return err
	}
	return proto.Unmarshal(b, this.Config)
}
func (this *ConfigService) Remove() error {
	err := lib.LocalCache.DropPrefix(this.Key())
	if err != nil {
		return err
	}
	return nil
}

// 加载所有配置
func LoadAllConfig() (ret []*ConfigService) {
	ret = make([]*ConfigService, 0)
	list, err := lib.LocalCache.Keys(10)
	if err != nil {
		return
	}
	//      /group/dataid/version    xxxx
	for _, item := range list {
		log.Println(item)
		if slist := strings.Split(item, "/"); len(slist) == 4 {
			ret = append(ret, NewConfigService(slist[1], slist[2], slist[3], nil))
		}
	}
	return
}

func LoadGroups() []string {

	set := lib.NewSet()
	list, err := lib.LocalCache.KeysWithPrefix(50, "/")
	if err != nil {
		return []string{}
	}
	for _, item := range list { //  /group/dataid/version
		s := strings.Split(item, "/")
		if len(s) == 4 {
			set.Add(s[1])
		}
	}
	return set.Values()
}
