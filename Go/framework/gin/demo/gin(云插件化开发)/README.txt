动态执行GO代码
  github.com/traefik/yaegi

  i := interp.New(interp.Options{})
	i.Use(stdlib.Symbols)
	_, err := i.Eval(`import "fmt"`)
	if err != nil {
		panic(err)
	}
	_, err = i.Eval(`fmt.Println("Hello world")`)
	if err != nil {
		panic(err)
	}

加载本地代码包
  i := interp.New(interp.Options{GoPath: "./ExtPlugins/NamePlugin/"})
	i.Use(stdlib.Symbols)
	if _, err := i.Eval(`import "github.com/shenyisyn/jtheader"`); err != nil {
		log.Fatal(err)
	}
	val, err := i.Eval(`jtheader.NewNamePlugin`)
	if err != nil {
		log.Fatal(err)
	}
	f:= &jtheader.NamePlugin{}
	fmt.Println(val.Call(nil)[0].Convert(reflect.TypeOf(f)).MethodByName("Name").Call(nil))

从github上获取项目
  https://github.com/google/go-github

  获取单个
    client := github.NewClient(nil)
    rep,_,err:=client.Repositories.Get(context.Background(),"shenyisyn","jtheader")
    if err!=nil{
      log.Fatal(err)
    }
    fmt.Println(*rep.URL,*rep.Name)
  
规定所有的插件必须打上一个topic,譬如叫做jtthink-plugin
  //curl -H "Accept: application/vnd.github.mercy-preview+json" "https://api.github.com/search/repositories?q=topic:XYZ
	client := github.NewClient(nil)

	ret,_,err:= client.Search.Repositories(context.Background(),
	 	"topic:jtthink-plugin",nil)
	if err!=nil{
		log.Fatal(err)
	}
    for _,rep:=range ret.Repositories{
    	fmt.Println(*rep.Name)
	}

从github上clone项目
  https://github.com/go-git/go-git

检查合法性
  yaml解析库
    https://github.com/go-yaml/yaml
    安装:go get gopkg.in/yaml.v2

  策略
    规定，用户必须上传一个文件叫做 .jtthink.yaml

    内容如下
      name: myheader
      import: github.com/shenyisyn/jtheader
      package: jtheader
      summary: 'myheader from jtthink'

    func FileExist(path string) bool {
      _, err := os.Lstat(path)
      return !os.IsNotExist(err)
    }

    加载配置
      type PluginConfig struct {
        Name string
        Import string
        Package string
        Summary string
      }

      func LoadConfig(path string ) (*PluginConfig,error){
        f,err:=os.Open(path)
        if err!=nil{
          return nil,err
        }
        b,err:=ioutil.ReadAll(f)
        if err!=nil{
          return nil,err
        }
        config := &PluginConfig{}

        err = yaml.Unmarshal(b, config)
        if err!=nil{
          return nil,err
        }
        return config,nil
      }


