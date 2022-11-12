所有权 
  Copy和Move很类似，拷贝后，不会销毁原有变量
  一个类型所有属性都实现了Copy，那么它本身就可以实现Copy
  常见数字类型 bool类型都已经实现了Copy
  凡是实现Drop trait的不能再实现Copy(String就是)
  Copy好比是一中浅拷贝 还有个Clone实现了深拷贝
  Copy告诉编译器这个类型默认采用copy语义，而不是move语义

  自定义struct实现clone
    #[derive(Debug, Default)]
    struct User {
      id: i32,
      name: String,
      age: i32
    }

    impl Clone for User {
      fn clone(&self) -> Self {
        User {
          id: self.id,
          name: self.name.clone() + "被克隆",
          age: self.age
        }
      }
    }

    let a: User = User{id: 123, ..Default::default()};
    let b: User = a.clone();

  传递参数所有权丢失问题
    fn load_user(u: &mut User) {
      u.age = 18;
    }

    fn main() {
        let mut a: User = User{id: 123, ..Default::default()};
        load_user(&mut a);

        println!("a={:?}", a);
    }

  可变引用排他性
    在同一个作用域内，创建可变引用的变量会被独占(排他)
    此时创建其他变量
      1. 使用原始变量
      2. 可变引用
      3. 不可变引用
    都会被抢占
    每次抢到独占锁后，都会将之前的所有引用变成不可用状态

    let mut user: User = User{id: 123, ..Default::default()};
    let u1: &mut User = &mut user;
    let u2: &mut User = &mut user; // print u1 will wrong
    let u2: &User = &user; // print u1 will wrong
    let u2: User = user; // print u1 will wrong
    let u2: User = user.clone(); // print u1 will wrong

Struct & trait 
  struct默认值
    #[derive(Debug, Default)]
    struct User {
      id: i32,
      name: String,
      age: i32
    }

    let a: User = User{id: 123, ..Default::default()};

  实现Display trait
    use std::fmt;
    impl fmt::Display for User {
      fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "user is {}, age is {}", self.id, self.age)
      }
    }
  
  函数重载
    pub trait UserInit<T> {
      fn new(v: T) -> Self;
    }

    impl UserInit<i32> for User {
      fn new(id: i32) -> Self {
        User{id: id, ..Default::default()}
      }
    }

    impl UserInit<&str> for User {
      fn new(name: &str) -> Self {
        User{name: name.to_string(), ..Default::default()}
      }
    }
  
  自定义struct字段默认值
    impl Default for User {
      fn default() -> Self {
        User{id: 0, name: String::from("guest"), age: 18}
      }
    }

    可以通过..Default::default()或者直接User::default()

JSON
  use serde::{Serialize, Deserialize};
  #[derive(Debug,Clone,Serialize,Deserialize)]
  pub struct User{
    pub id:i32,
    // 重命名json字段
    #[serde(rename(serialize = "user_name",deserialize="user_name"))]
    pub name: String,//guest
    // 默认值
    #[serde(default="User::default_age")]
    pub age:i32 ,
    // 默认值
    #[serde(default)]
    pub admin:bool
  }

  序列化
    serde_json::to_string_pretty(&u).unwrap()

  反序列化
    let user_str=r#"
    {
        "id": 0,
        "user_name": "guest"
      }
    "#;

    let user:User=serde_json::from_str(user_str).unwrap();

  自定义序列化
    use serde::{Serialize, Deserialize,Serializer};
    use serde::ser::SerializeStruct;

    impl Serialize for User {
      fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
          where
              S: serde::Serializer {
                let mut s = serializer.serialize_struct("User", 4)?;
                s.serialize_field("user_id", &self.id)?;
                s.serialize_field("user_name", &self.name)?;
                s.end()
      }
    }
  
  非结构体反序列化和取值
    let user_str=r#"
    {
        "id": 0,
        "user_name": "guest",
        "friends":["shenyi","zhangsan"],
        "roles":[
             {"name":"admin"},
             {"name":"guest"}
        ]
      }
    "#;
    let user:serde_json::Value=serde_json::from_str(user_str).unwrap();
    println!("{}",user.as_object().and_then(|v| v.get("roles"))
    .and_then(|v| v.get(0)).and_then(|v| v.get("name")).unwrap());

  闭包
    let str: String = String::from("desmond");
    let f = || {
      println!("{}", str);
    }
    f();

    闭包作为参数传递
      fn exec<F>(f: F) 
      where F:Fn() 
      {
        f();
      }

      let str: String = String::from("desmond");
      let f = || {
        println!("{}", str);
      }
      exec(f);
      exec(f);
    
    闭包作为struct字段
      第一种
        struct User<F> 
        where F: Fn() 
        {
          id: i32,
          info: F
        }

        let str: String = String::from("desmond");
        let f = || {
          println!("{}", str);
        }
        let u: User = User{id: 101, info: f};
        (u.info)();
        // 或者
        // let info = u.info;
        // info();

      第二种
        struct User<'a> {
          id: i32,
          info: &'a dyn Fn()
        }
        let str: String = String::from("desmond");
        let f = || {
          println!("{}", str);
        }
        let u: User = User{id: 101, info: &f};
        let info = u.info;
        info();

    Fn(&self) 引用(&T) 不改变和释放变量，可多次运行
      let str: String = String::from("desmond");
      let f = || {
        println!("{}", str);
      }
      f();
      f();

    FnMut(&mut self) 可变引用 (&mut T)  可更改捕获的变量，对变量进行了可变借用
      fn myfn<F: FnMut()>(mut f) {
        f();
      }

      let mut str = String::from("desmond");
      let mut f = || {
        let a = &mut str;
        a.push_str("123");
      }
      f();
      myfn(f);
      println!("{}", str);

    FnOnce(self) 值 (T)  移动了所捕获变量的所有权
      fn myfnOnce<F: FnOnce()>(f) {
        f();
      }

      let str = String::from("desmond");
      let f = || {
        let mut a = str;
        a.push_str("123");
        println!("{}", a);
      }
      myfnOnce(f);
      
    总结
      所有的闭包都实现了FnOnce()
      1. 如移动所捕获的变量所有权，则只实现FnOnce
      2. 如没有移动所捕获的变量所有权(引用)，并且对变量进行了可变操作，则实现FnMut
      3. 引用+不可变，则实现Fn
    
