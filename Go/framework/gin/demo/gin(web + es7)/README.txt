部署es7
  docker pull blacktop/elasticsearch:7.4
  docker tag blacktop/elasticsearch:7.4 es:74
  docker run -d --name es -p 9200:9200 es:74

部署kibana(注意版本要与es一致)
  一款为 Elasticsearch设计的分析和可视化工具。你可以使用 Kibana 来操作 如增删改查 Elasticsearch 索引中的数据并与之交互
  docker pull blacktop/kibana:7.4
  docker tag blacktop/kibana:7.4 kb:74

启动kibana
  docker run --init -d --name kb \
    -e elasticsearch.hosts="http://192.168.29.135:9200"   \
    -p 5601:5601  \
    kb:74

go客户端库
  https://github.com/olivere/elastic/
  go get github.com/olivere/elastic/v7

es  
  mapping
    mapping映射类似于在数据库中定义表结构， 表里面有哪些字段、字段是什么类型 
    https://www.elastic.co/guide/en/elasticsearch/reference/7.4/mapping.html
  
    创建
      PUT news
      {
        "mappings": {
          "properties": {
            "news_title": {
              "type":  "text"
            },
            "news_type": {
              "type":  "keyword"
            },
            "news_status": {
              "type":  "byte"
            }
          }
        }
      }

    使用PostMan查看
      GET http://192.168.29.135:9200/news/_mapping

  查看某条数据
    GET http://192.168.29.135:9200/news/_doc/:id
  
  term 可以认为是精确查询
    "query": {
      "term": {
        "BookPress": "人民邮电出版社"
      }
    }
  
  match
    GET /books/_search
    {
      "query":{
        "match": {
          "BookName": "程序教程"
        }
      }
    }
  
  分析器
    ES内部有一些分析器（分析器由：分词器和过滤器组成）,其中最常用的是standard标准分析器
    POST _analyze
    {
      "analyzer": "standard",
      "text" : "程序教程"
    }

    中文分析器
      https://github.com/medcl/elasticsearch-analysis-ik/releases (版本要与es版本对应)
      下载ik分词器需要放到es目录下的plugins目录(例如在该目录下创建一个文件夹叫ik,然后把下载的内容拷贝进去),然后重启es

      POST  _analyze
      {
        "analyzer": "ik_smart",
        "text" : "程序教程java"
      }

      ik分析器 有两个 ik_smart 和ik_max_word 后者颗粒度更细

  高亮搜索
    高亮 显示部分文本片段，以便让用户知道为何该文档符合查询条件

    GET /books/_search
    {
      "query":{
        "match": {
          "BookName": "程序教程"
        }
      },
      "highlight" : {
        "pre_tags" : ["<tag1>"],
        "post_tags" : ["</tag1>"],
        "fields" : {
          "BookName" : {}
        }
      }
    }

  折叠(实现distinct)
    GET /books/_search
    {
      "_source": ["BookPress"]
    }
    好比执行了 select book_press from books limit 10

    distinct
      GET /books/_search
      {
        "_source":"",
        "collapse": {
          "field": "BookPress"
        },
        "size": 10
      }
  
  Bool查询(组合查询)
    允许在单独的查询中组合任意数量的查询
    好比select xxx from table where xx=xx and xxx =xx ///  xxx=xxx or xxx=xx // xxx!=xx
    有must，must_not以及should
    {
      "query": {
        "bool": {
          "must": [
            {
              "term": {
                "BookPress":"人民邮电出版社"
              }
            },
            {
              "match": {
                "BookName": "java"
              }
            }
          ]
        }
      }
    }
  
  范围查询
    GET /books/_search
    {
      "query":{
        "range": {
          "BookPrice1": {
            "gte": 100,
            "lte": 200
          }
        }
      }
    }

    应用到bool查询中
      GET /books/_search
      {
        "query": {
          "bool": {
            "must": [
              {"term":{"BookPress":"人民邮电出版社"}},
              {"match": {"BookName": "java"}},
              {"range": {
                "BookPrice1": {
                  "gte": 100,
                  "lte": 200
                }
              }}
            ]
          }
        }
      }
  
  排序
    ES的数据取出，默认是按照相关性排序的,相关性越高，排名越靠前

    GET /books/_search
    {
      "query": {
        "bool": {
          "must": [
            {"term":{"BookPress":"人民邮电出版社"}},
            {"match": {"BookName": "java"}},
            {"range": {
              "BookPrice1": {
                "gte": 100,
                "lte": 200
              }
            }}
          ]
        }
      },
      "sort": [
        {
          "_score": {
            "order": "desc"
          }
        }
      ]
    }
  
  分页
    和mysql一样，mysql有 select xx ,xx from table limit 0,10 或 limit xxx offset xxx
    ES里用的方式是from xxx size xxxx    
    不过和mysql一样，翻页数量比较大时，性能比较差,此方法适合5000页以内的翻页

    GET /books/_search
    {
      "from": 0,
      "size": 3, 
      "query": {
        "bool": {
          "must": [
            {"term":{"BookPress":"人民邮电出版社"}},
            {"match": {"BookName": "java"}},
            {"range": {
              "BookPrice1": {
                "gte": 100,
                "lte": 200
              }
            }}
          ]
        }
      }
    }

    ES有个内置变量叫做max_result_window(默认是10000)，当from+size >10000时会报错
    手工改(不推荐改太大)
      PUT /books/_settings
      {
        "index.max_result_window":10000
      }
  
  删数据
    POST /bookslogs/_delete_by_query
    {
      "query": {
        "match_all": {}
      }
    }

    或者

    DELETE /bookslogs

  聚合查询
    2个最简单的聚合类型
      Metrics类型(指标) avg、max、min、sum、stats
        POST /bookslogs/_search?size=0
        {
          "aggs" : {
            "max_time" : 
            { 
              "max" : 
              { 
                "field" : "duration" 
              } 
            }
          }
        }

      Bucket类型(分桶): 类似SQL中的group by

    terms聚合
      POST /bookslogs/_search?size=0
      {
        "aggs": {
          “urlcount": {
            "terms": {
              "field": "url"
            }
          }
        }
      }
      会报错如果url为text类型,参照https://www.elastic.co/guide/en/elasticsearch/reference/current/fielddata.html

      解决方法
        修改mapping，使之映射到一个keyword类型中专门用于聚合
        POST /bookslogs/_search?size=0
        {
          "aggs": {
            "urlcount": {
              "terms": {
                "field": "url.keyword",
                "order": {
                  "url_max": "desc"
                }
              },
              "aggs":{
                "url_max":{
                  "max":{"field": "duration"}
                }
              }
            }
          }
        }
  
  filter
    POST /bookslogs/_search?size=0
    {
      "aggs":{
        "url":{
          "terms": {
            "field": "url.keyword",
            "size": 5,
            "order": {
              "bymethod>max_time": "desc"
            }
          },
          "aggs": {
            "bymethod":{
              "filter": {"term": { "method": "POST"}},
              "aggs":{"max_time": {"max": {"field":"duration"}}}
            }
          }
        }
      }
    }

  迁移数据
    POST _reindex
    {
      "source":
      {
        "index":"bookslogs"
      },
      "dest": 
        {
        "index":"bookslogs_2" 
      }
    } 
  
  添加别名
    POST _aliases
    {
      "actions": [
        {
          "add": {
            "index": "bookslogs",
            "alias": "bookslogs_2"
          }
        }
      ]
    }

GraphQL
  https://github.com/graphql-go/graphql
  
  用于集成到gin的库
    https://github.com/graphql-go/handler

项目
  下载数据
    http://www.jtthink.com/download/detail?did=235
    http://www.jtthink.com/download/detail?did=236

  创建mapping
    PUT /books
    {
      "mappings": {
        "properties": {
          "BookID":    { "type": "integer" },
          "BookName":    { "type": "text","analyzer": "ik_max_word","search_analyzer": "ik_smart" },  
          "BookIntr":  { "type": "text" ,"analyzer": "ik_max_word","search_analyzer": "ik_smart" }, 
          "BookPrice1":   { "type": "float"},  
          "BookPrice2":   { "type": "float"},  
          "BookAuthor":   { "type": "keyword"},
          "BookPress":   { "type": "keyword"},
          "BookDate":   { "type": "date"},
          "BookKind":   { "type": "integer"}
        }
      }
    }

    PUT /bookslogs
    {
      "mappings": {
        "properties": {
          "ip":    { "type": "text" },
          "status":    { "type": "integer"},  
          "duration":   { "type": "integer"},  
          "method":   { "type": "keyword"},  
          "url":   { 
            "type": "text",
            "fields": {
              "keyword": { 
                "type": "keyword"
              }
            }
          },
          "time":   { "type": "date","format": "strict_date_optional_time||epoch_millis||dd/MMM/yyyy:HH:mm:ss Z"},
          "level":   { "type": "keyword"},
          "msg":  { "type": "text"},
          "referer":  { "type": "text"},
          "agent": { "type": "text"}
        }
      }
    }
  
  安装Go ORM库
    go get github.com/jinzhu/gorm

  手工插入
    POST /books/_doc/19552
    {
    "BookID":19552,
    "BookName":" C语言程序设计实验指导与习题解答",
    "BookIntr":"导语_点评_推荐词",
    "BookPrice1":19,
    "BookPrice2":19,
    "BookAuthor":"蒋清明",
    "BookPress":"人民邮电出版社",
    "BookDate":" 2008-10-01",
    "BookKind":8
    }
  
  批量插入
    POST _bulk
    { "index" : { "_index" : "books", "_id" : "19552" } }
    {"BookID":19552,"BookName":" C语言程序设计实验指导与习题解答","BookIntr":"导语_点评_推荐词","BookPrice1":19,"BookPrice2":19,"BookAuthor":"蒋清明","BookPress":"人民邮电出版社","BookDate":" 2008-10-01","BookKind":8}
    { "index" : { "_index" : "books", "_id" : "19550" } }
    {"BookID":19550,"BookName":" C语言程序设计教程（第二版）","BookIntr":"","BookPrice1":37.9,"BookPrice2":40,"BookAuthor":"王绪梅詹春华陈剑锋","BookPress":"科学出版社","BookDate":" 2015-05-04","BookKind":8}

  安装gin
    go get github.com/gin-gonic/gin

  logrus日志库
    go get github.com/sirupsen/logrus
    可以配置hook