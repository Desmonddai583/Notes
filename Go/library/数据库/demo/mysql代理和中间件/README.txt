go get -u  github.com/siddontang/go-mysql
这不是一个纯mysql驱动。而是包含了mysql协议解析、复制（MySQL Replication）和类java canal功能的第三方底层库

https://github.com/xwb1989/sqlparser 基于 vitessio/vitess  (数据库中间件)

数据库分表拆分分为垂直拆分和水平拆分
  水平拆分分表规则
    1、按某个字段范围分  id 1 1000  users1 1001 3000 users2 
      譬如 以ID为例：
        0—500 是users1
        501—1000是users2
        不符合规则统统放入users2
    2、按某个字段取模  24 % 4 =0
    3、按枚举 男 女

  如果有where语句，且id字段是我们的配置字段，如
    sql := "select user_id,user_name from  users u where id=60 order by u.id desc  limit 0,10“
  会变成
   select user_id,user_name from  users1 u where id=60 order by u.id desc  limit 0,10
  如果没有where语句，则拆分成:
  1、select user_id, user_name from users1 as u order by u.id desc limit 0, 10
  2、select user_id, user_name from users2 as u order by u.id desc limit 0, 10

  如果SQL是这样
  select user_id,user_name from  users  u where id=60 and name='abc' order by u.id desc limit 0,10
  这里面就有多个where条件
  此时where的类型就不再是ComparisonExpr ，而是AndExpr
  基本解析是这样的：
    譬如：id=60 and name='abc' and age=12
    第一次取Left: id=60 and name=‘abc’  （right是 age=12）
    再取一次Left: id=60 (right 是name=‘abc’)

  如果有where语句，且id字段是我们的配置字段，如
  sql := "select user_id,user_name from  users u where id>60 and age=12 and id<80 order by u.id desc  limit 0,10“
  会变成 select user_id,user_name from  users1 u where id=60 order by u.id desc limit 0,10
  如果没有where语句，则拆分成:
  1、select user_id, user_name from users1 as u order by u.id desc limit 0, 10
  2、select user_id, user_name from users2 as u order by u.id desc limit 0, 10

第三方的set库 https://github.com/deckarep/golang-set
  可以方便的实现
  切片的交集、并集、差集等等
  go get github.com/deckarep/golang-set

常见的mysql中间件
  https://github.com/flike/kingshard  (go做的中间件)
  Mycat (之前课程介绍过)
  Vitess (本课程用的SQL解析库就是它的)
  Sharding-JDBC (https://github.com/apache/incubator-shardingsphere)

数据量再大点，建议了解下newsql （如TiDB）
  https://github.com/pingcap/tidb


