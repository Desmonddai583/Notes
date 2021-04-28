Cargo
  cargo是rust 的代码（项目）组织和管理工具,提供项目的建立、构建到测试、运行直至部署

  最基本的项目
    cargo new xxxx
    cargo build 
    cargo run

常见的基本类型
  有符号整型（signed integers）：i8、i16、i32、i64 和 isize（指针大小）
  无符号整型（unsigned integers）： u8、u16、u32、u64 和 usize（指针大小）
  浮点类型（floating point）： f32、f64
  char（字符）：单个 Unicode 字符，如 'a'，'α'  
  bool（布尔型）：true 、false
  单元类型（unit type）：(),有且仅有一个值，写成小括号()
  数组（array）：如 [1, 2, 3]
  元组（tuple）：如 (1, true)

  定义一个数字
    let myage:i32=29000;
    let myage=29000; // 会自动推断 （在数字层面，默认就是i32）

  最大值与最小值
    i8::max_value()
    i8::min_value()


  
创建自定义函数
  fn show_me() {
    let my_name="shenyi";
    let my_age=19;
    println!("我的姓名:{},我的年龄:{}",my_name,my_age)
  }

模块
  基本语法
    mod {
      pub fn xxx()
    }

变量命名
  默认应该使用snake_case
  如果就是要驼峰则可以在文件中写入
  #![allow(non_snake_case)]

字符串
  Rust主要有 &str 和String 

  &str
    它是一个引用

    let name="shenyi“
    1、在内存中写入 shenyi 
    2、创建一个引用(&)赋给name这个变量
    我们不能直接操作str。需要加一个&来操作它的“引用”
    &str好比是一个固定长度的字符序列（数组）

    完整写法 let name:&'static str="shenyi";
  
  String
    String分配在堆里
    let name = String::from("abc");
    println!("{:p}", name.as_ptr());
    {}，针对基本类型如int、&str等，都可以直接打印(它们都有对应的Display方法)。如果对象或后面我们自定义的struct时，则打不了
    Rust里面主要是Display和Debug方法要实现
    RUST中常见的符号
      unspecified -> Display   {}
      ? -> Debug
      o –> Octal //8进制
      x –> LowerHex //16进制
      X -> UpperHex
      p –> Pointer
      b –> Binary //二进制
  
  str, 存在于栈中，性能高。通常以&str的方式引用
  String, 分配在堆中，属于RUST标准库提供的功能,可增长、可变、有所有权、UTF-8 编码的字符串类型
    String::new()
    String::from

    let mut name=String::new();
    name.push_str("shen");
    name.push_str("yi");
    println!("{}",name);

  所有者
    let name = String::from(“shenyi");
    name就是abc所有者
    在Rust里面有且只有一个所有者,当所有者离开作用域，这个值将被抛弃

    let me = String::from("shenyi");
    println!("ptr is : {:p}", me.as_ptr());
    let you =me; 
    原本我叫“shenyi”. 现在你叫”shenyi”
    而“我” 就作废了。这就是所有者的最基本概念

    解决方法
      let me = String::from("shenyi");
      println!("ptr is : {:p}", me.as_ptr());
      let you =me.clone(); 
      此时me和you内存地址不同,指向堆中的String的位置也不同(只是里面放的内容一样)

      或者
      let you = &me
      此时其实是you成为了me的所有者,此时as_ptr的值相等
    
      以上问题只在String时出现,&str就不需要考虑,直接let you = me即可
    
    函数传参时的所有者转移
      fn show_length(s: String) { //在这里s获得了所有权
        println!("{}", s.len());
      } //到这里 s 被释放。对应的值在堆中木有了
      fn main() {
        let me = String::from("shenyi");
        show_length(me);    
      }

      不转移的写法
        fn show_length(s:&String) {
          println!("{}", s.len());
        }
        fn main() {
          let me = String::from("shenyi");
          show_length(&me);
          println!("{}", me);
        }
      
      修改值
        fn show_length(s: &mut String)  {
          s.push_str("_19");
        }
        fn main() {
          let mut  me = String::from("shenyi");
          show_length(&mut me);
          println!("{}", me);
        }

表达式
  Rust是一个以表达式为主的语言
  let a=1;  这是语句
  if (a == b)  这里面a==b 就是表达式 
  表达式：可以包括定义某值，或判断某物，最终会有一个“值”的体现

  if 条件
    fn add(a:i32) -> i32{
      a+1
    }
    注意：a+1后面没有分号。 它的值最终体现为4

  fn get_user(uid:i32)->&'static str{
    let ret = if uid==10{
      "shenyi"
    }else if uid==102{
      "zhangsan"
    }else {
      "李四"
    };
    ret 
  } 

match语法
  match html.len() {
    4 => println!("OK"),
    0..=3 =>  println!("太短了"),
    _ => println!("太长了")
  }

Struct
  struct User{
    name: String,
    age: u8
  }

  定义结构体方法使用impl关键字
    impl User {
      fn to_string(&self) -> String{
        return String::from(format!("我的年龄是:{},年龄是:{}",&self.name,&self.age));
      }
      fn get_age(&self)->&u8{
        &self.age
      }
    }

  对于Debug方法
    只要加入一个类似注解的文字
    #[derive(Debug)]

数组
  let tags:[&str;3] = ["a", "b", "c"];

  循环数组
    for item in tags.iter() {
      ...
    }
    或者
    let mut tags:[u8;10] = [0;10];
    for i in 0..tags.len() {
      tags[i] = (i+1) as u8
    }
    或者以元组方式遍历
    let mut tags:[u8;10] = [0;10];
    for (i, item) in tags.iter().enumerate() {
      ...
    } 
  
  定义空数组
    let tags:[&str;10] = ["";10];

元组
  元组是长度固定并且各项值的类型可以不同的集合
  let my:(&str,u8) = ("shenyi", 19);

trait
  定义两个struct
    #[derive(Debug)]
    pub struct Book {
      id :i32,
      price: f32 
    }
    #[derive(Debug)]
    pub struct Phone {
      id :i32,
      price: f32 
    }

  定义trait方法
    use crate::models::prod_model::Book;
    impl Prods for Book {
      fn get_price(&self) -> f32 {
        let new_price = &self.price;
        new_price + 10.0
      }
    }
  
  调用
    mod models;
    mod traits;
    use models::prod_model::*;
    use traits::Prods;
    fn main() {
      let book = new_book(101, 20.0);
      println!("{:?}", book.get_price());
    }

  在函数中传trait作为参数
    第一种
      fn show_prod(p: impl Prods) {
        println!("商品价格是{}", p.get_price());
      }
    第二种
      fn show_prod<T:Prods>(p: T) {
        println!("商品价格是{}", p.get_price());
      }

生命周期
  &str它的本质是 str。而且是被保存在“二进制文件中的”,使用时使用引用的方式来借用他
  static生命周期贯穿于整个程序,因此严格来讲叫做静态生存期

枚举值的比较
  第一种 使用match来进行解构
    match u.sex{
        Sex::Male=>{
            println!("男性");
        },
        Sex::Female=>{
            println!("女性");
        },
    };
  
  第二种
    if let Sex::Male = u.sex{
        println!("{}","男性");
    }else {
        println!("{}","女性");
    }

  Option枚举
    enum Option<T> {
      Some(T),
      None,
    }
    用来表达存在或不存在（也就是空值）

    Some
      可以是任意类型
      看下面的定义
      struct User {
          id: i32,
          sex: Option<String>,
      }
