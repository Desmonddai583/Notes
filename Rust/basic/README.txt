Rust是静态强类型语言

Cargo
  cargo是rust 的代码（项目）组织和管理工具,提供项目的建立、构建到测试、运行直至部署

  最基本的项目
    cargo new xxxx
    cargo build 
    cargo run

创建变量 let, 变量默认不可变
  可变变量 名称前加mut
常量 const
常量是在编译期间进行求值，不可变变量是在运行期间，常量后面可以跟上任何常量表达式，但是如果是放一个例如函数的返回值就不行，而不可变变量就可以
shadowing 
  let x = 5
  let x = x + 1
  新变量会隐藏前面的变量

常见的基本类型
  有符号整型（signed integers）：i8、i16、i32、i64、i128 和 isize（指针大小）
  无符号整型（unsigned integers）： u8、u16、u32、u64、u128 和 usize（指针大小）
  未标注类型的整数默认i32
  isize 和 usize根据系统不同而有不同长度，64位系统就是64位，32位就是32, 通常用于索引某种数据集合时比如数组下标就是usize
  浮点类型（floating point）： f32、f64 默认f64 
  char（字符）：单个 Unicode 字符，如 'a'，'α'  
  bool（布尔型）：true 、
    false bool大小是一个字节
  单元类型（unit type）：(),有且仅有一个值，写成小括号()
  数组（array）：如 [1, 2, 3]
  元组（tuple）：如 (1, true)

  定义一个数字
    let myage:i32=29000;
    let myage=29000; // 会自动推断 （在数字层面，默认就是i32）
    

  最大值与最小值
    i8::max_value()
    i8::min_value()

  整数溢出问题
    如果预期计算会出现溢出可以使用
      let (sum, is_overflow) = a.overflowing_add(b);
    防止出现不可预期的错误

函数
  创建自定义函数
    fn show_me() {
      let my_name="shenyi";
      let my_age=19;
      println!("我的姓名:{},我的年龄:{}",my_name,my_age)
    }

  闭包
    let times3 = |n: u32| -> u32 { n * 3 };
    time3(10);

    move 将环境中的值移到闭包内部  在多线程使用场景下可以从主线程移动值到子线程
    use std::thread;

    let hell0 = "hello";
    thread::spawn(move || {
      println!("{}", hello);
    }).join();

  高阶函数
    type Method = fn(u32, u32) -> u32;
    fn calc(method: &str) -> Method {
      match method {
        "add" => add,
        _ => unimplemented!(),
      }
    }
    fn add(a: u32, b: u32) -> u32 {
      a + b
    }
    calc("add")(10, 10);

  发散函数
    发散函数永远不会被返回，他们的返回值被标记为!，这是一个空类型
      fn foo() => ! {
        panic!("this call never return");
      }
    
    与空返回值函数不同，空返回值函数可以被返回
      fn some_fn() {
        ()
      }
      let a: () = some_fn();
    
    发散函数最大的用处是通过Rust的类型检查，因为发散函数类型可以是任意类型，例如在if-else中要求必须返回相同类型，那可以这么写
      fn foo() => ! {
        panic!("never return");
      }
      let a = if true {
        10
      } else {
        foo()
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

  loop也可以有返回值(通过break返回)
    let a = loop {
      if n < 0 {
        break s;
      }
      n -= 1;
    }

流程控制
  如果使用if-else返回一个值，则所有分支必须返回相同类型

  iter_mut使用
    let mut myarr = [1, 2, 3];
    for i in myarr.iter_mut() {
      *I *= 2;
    }
  
  while let 

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

  元组结构定义
    struct Pair(i32, f32);
    let pair = Pair(10, 4.2);
    pair.0
  
  单元结构定义 通常用于泛型
    struct Unit;
    let unit = Unit;

  定义结构体方法使用impl关键字
    impl User {
      fn to_string(&self) -> String{
        return String::from(format!("我的年龄是:{},年龄是:{}",&self.name,&self.age));
      }
      fn get_age(&self)->&u8{
        &self.age
      }
      fn set_age(&mut &self, age: u64) {
        self.age = age;
      }
    }

  对于Debug方法
    只要加入一个类似注解的文字
    #[derive(Debug)]  派生属性 
    会自动实现一些功能,例如打印结构体变量,此时在println中就可以通过{:?}来打印

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

  切片 对原数组的一个引用，没有产生复制
    let slice = &arr[0..3];
    slice.len()
    slice.is_empty()

元组
  元组是长度固定并且各项值的类型可以不同的集合
  let my:(&str,u8) = ("shenyi", 19);
  
  模式匹配解封装
  let (a, b) = my_tuple;

  元组取值
  my_tuple.0

  经常可以作为函数的返回值

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
    match u.sex {
        Sex::Male=>{
            println!("男性");
        }
        Sex::Female=>{
            println!("女性");
        }
        _ => {
          println!("unknown");
        }
    };
  
  第二种
    if let Sex::Male = u.sex {
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

注释
  普通注释
    //  注释单行
    /* */ 注释多行

  文档注释
    文档注释是一种 Markdown 格式的注释，用于对文档中的代码生成文档，可以使用 cargo doc 工具生成 HTML 文挡
    //! 这是模块级别的文档注释，一般用于模块文件的头部
    /// 这是文档注释，一般用于函数或结构体的说明，置于说明对象的上方

println!
  println!("{}", 42);
  println!("{0}{1}{0}", 4, 2);
  println!("name={name} age={age}", name="jack", age=6);
  println!("{} of {:b} people know binary, the other half don't", 1, 2); // 可以在 `:` 后面指定特殊的格式
  println!("{number:>width$}", number=1, width=6);  // 可以按指定宽度来右对齐文本
  println!("{number:>0width$}", number=1, width=6); // 在数字左边补 0. 语句输出 "000001".

类型转换
  as
    通常用于整数 浮点数和字符数据之间的转换
    let a: i8 = -10;
    let b = a as u8; // 246

    两个相同大小的整型之间（例如：i32->u32）的转换是一个no-op
    从一个大的整型转换为一个小的整型（例如：u32->u8）会截断
    从一个小的整型转换为一个大的整型（例如：u8->u32）会
      如果源类型是无符号的会补零（zero-extend）
      如果源类型是有符号的会符号（sign-extend）
    从一个浮点转换为一个整型会向 0 舍入
    从一个整型转换为一个浮点会产生整型的浮点表示，如有必要会舍入（未指定舍入策略）
    从 f32 转换为 f64 是完美无缺的
    从 f64 转换为 f32 会产生最接近的可能值（未指定舍入策略）

  transmute
    as只允许安全的转换，并会拒绝例如尝试将 4 个字节转换为一个u32
    这是一个“非标量转换（non-scalar cast）”因为这里我们有多个值：四个元素的数组。
    这种类型的转换是非常危险的，因为他们假设多种底层结构的实现方式。为此，我们需要一些更危险的东西  
    transmute函数由编译器固有功能提供，它做的工作非常简单，不过非常可怕。它告诉Rust对待一个类型的值就像它是另一个类型一样。它这样做并不管类型检查系统，并完全信任你
    为了使它编译通过我们要把这些操作封装到一个unsafe块中
      use std::mem;

      unsafe {
        let a = [0u8, 1u8, 0u8, 0u8];
        let b = mem::transmute::<[u8; 4], u32>(a);
        println!("{}", b); // 256
        // Or, more concisely:
        let c: u32 = mem::transmute(a);
        println!("{}", c); // 256
     }