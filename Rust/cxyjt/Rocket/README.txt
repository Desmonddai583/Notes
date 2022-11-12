Rocket
  https://github.com/SergioBenitez/Rocket

  文档地址： https://rocket.rs/v0.4/guide/getting-started/

  Cargo.toml
  [dependencies]
  rocket = "0.4.5"

  加入申明注解
    #![feature(proc_macro_hygiene, decl_macro)]
    #[macro_use] extern crate rocket;

  定义路由
    #[get("/")]
    fn index() -> &'static str{
        "index"
    }

  挂载
    fn main() {
      let rocket=rocket::ignite().mount("/v1", routes![index,user]);
      rocket.launch();
    }

Rocket支持几个配置
  development (short: dev)
  staging (short: stage)
  production (short: prod)

  Rocket.toml写入
  [development]
  address = "0.0.0.0"
  port = 8080

  运行时只需
    set ROCKET_ENV=development&&cargo run
  Linux 直接
    ROCKET_ENV=development cargo run

获取参数
  #[get("/users/<uid>")]
  fn user_detail(uid:i32)->String{
      format!("user detail {}",uid)
  }

对象JSON化输出、Serde库使用
  [dependencies]
  rocket = "0.4“
  serde = { version = "1.0", features = ["derive"] }
  serde_json = "1.0"

  模型
    use serde::{Serialize};

    #[derive(Serialize)]
    pub struct UserModel{
      pub user_id :i32,
      pub user_name:String
    }

  函数
    #[get("/users/<uid>")]
    fn users_detail(uid:i32)->String{
        let user=UserModel{user_id:uid,user_name:"test".to_string()};
        let user_json = serde_json::to_string(&user).unwrap();
        user_json
    }

  Responder的初步使用
    上面的方法,当我们返回String时，content-type并没有发生改变

    改进写法
      use rocket::response::content;

      fn users_detail(uid:i32)->content::Json<String>{
          let user=UserModel{user_id:uid,user_name:String::from("test")};
          content::Json(serde_json::to_string(&user).unwrap())
      }

    为什么response能返回&str也能返回String
      内置Responder(这是个trait)
      &str    set Content-Type text/plain. The string is used as the body of the response 
      String    set Content-Type to text/plain. The string is used as the body of the response 

    如何实现可以返回自定义模型
      use std::io::Cursor;
      use rocket::request::Request;
      use rocket::response::{self, Response, Responder};
      use rocket::http::ContentType;

      impl<'a> Responder<'a> for UserModel {
          fn respond_to(self, _: &Request) -> response::Result<'a> {
              let json=serde_json::to_string(&self).unwrap();
              Response::build()
                  .sized_body(Cursor::new(json))
                  .header(ContentType::new("application", "json"))
                  .ok()
          }
      }

  自定义JSON结构输出
    上面的方法要想UserModel输出JSON，必须实现Resonder的respond_to方法
    如果有多个model，总不能每个都实现一次
    
    解决方法
      创建一个基本结构
        use serde::{Serialize};
        use std::io::Cursor;
        use rocket::request::Request;
        use rocket::response::{self, Response, Responder};
        use rocket::http::ContentType;
        #[derive(Debug)]
        pub struct Json<T>(pub T);  //元祖式的struct，使用泛型

      实现Repond_To方法
        impl<'a, T: Serialize> Responder<'a> for Json<T> {
            fn respond_to(self, req: &Request) -> response::Result<'a> {
                let json=serde_json::to_string(&self.0).unwrap();
                Response::build()
                .sized_body(Cursor::new(json))
                .header(ContentType::new("application", "json"))  
                .ok()
            }
        }

获取query参数
  #[get("/users?<page>&<size>")]
  fn users(page:Option<i32>,size:Option<i32>)->String{
      let get_page=page.unwrap_or(1);
      let get_size=size.unwrap_or(10);
      format!("用户列表,page:{},size:{}",get_page,get_size)
  }

相同请求url的优先级设置
  GET  /user/123     代表获取id=123的用户信息
  GET /user/a001   代表获取id=a001的用户信息
  
  此时如果写两个相同的路由就会报错
    #[get("/users/<uid>")]
    ......
    #[get("/users/<uid>")]
    ......

  加入rank参数
    #[get("/users/<uid>",rank=1)]
    fn users_detail(uid:i32)->Json<UserModel>{
        Json(UserModel{user_id:uid,user_name:String::from("test")})
    }

rocket_contrib 获取JSON请求参数的方法
  [dependencies.rocket_contrib]
  version = "0.4.5"
  default-features = false
  features = ["json"]

  use rocket_contrib::json::Json;

  #[post("/users", format = "json", data = "<user>")]
  fn users_post(user:Json<UserModel<i32>>)->Json<UserModel<i32>>{
        user
  }

  UserModel需要加入 #[derive(Serialize,Deserialize)]

自定义json字段输出  
  这个和Rocket本身没有关系
  文档 https://serde.rs/variant-attrs.html
  #[serde(rename(serialize = "uid", deserialize = "uid"))]
  serialize指的是输出时字段名,deserialize值输入时字段名

mysql交互
  基本用法
    use mysql::*;
    use mysql::prelude::*;

    连接字符串
    let dsn = "mysql://root:123123@192.168.29.1:3307/test";
        let pool = Pool::new(dsn).unwrap();
        let ret: Option<(i32, String)> = pool
            .get_conn()
            .unwrap()
            .query_first("select user_id,user_name from users where user_id=1  ")
            .unwrap();

        println!("{:?}", ret.unwrap().0);

  简单封装DB初始化过程、连接池参数设置
    use mysql::prelude::*;
    use mysql::*;
    static mut DB_POOL: Option<Pool> = None;
    pub fn init_db() {
        let dsn = "mysql://root:123123@192.168.29.1:3307/test";
        unsafe {
            DB_POOL = Some(Pool::new_manual(5, 10, dsn).unwrap());
        }
    }
    pub fn db() -> Result<PooledConn> {
        unsafe {
            match &DB_POOL {
                Some(pool) => pool.get_conn(),
                None => {
                    panic!("you should call init db");
                }
            }
        }
    }
  
  Sql预处理
    let stmt = conn
      .prep("select user_id,user_name from users where user_id=?")
      .unwrap();

    第一种参数传递
      let ret: Option<(i32, String)> = conn.exec_first(&stmt, (3,)).unwrap();
      let ret2 = conn.exec_map(&stmt, (3,), |(uid, uname)| UserModel {
          user_id: uid,
          user_name: uname,
      })
      .unwrap();

    第二种参数传递
      let ret: Option<(i32, String)> = conn.exec_first(&stmt, params! {"uid"=>3}).unwrap();
      let ret2 = conn .exec_map(&stmt, params! {"uid"=>3}, |(uid, uname)| UserModel {
          user_id: uid,
          user_name: uname,
      })
      .unwrap();

  实现数据插入
    let stmt = conn
      .prep("insert into user_coins(username,coins) values(?,?)")
      .unwrap();

    不需要得到结果
      conn.exec_drop(&stmt,
         ("lisi",123)).unwrap();

    TextQuery(字符串)的方式执行
      let ret="insert into user_coins(username,coins)
        values(?,?)
        ".with(("lisi",10)).run(conn).unwrap();
        println!("{:?}",ret.affected_rows());

      Select也可以
        let users="select user_id,user_name from users".map(&mut conn, |(uid,uname)|{
            UserModel{
                user_id:uid,
                user_name:uname
            }
        }).unwrap();