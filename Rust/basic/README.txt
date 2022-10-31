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

模块化管理
  Package
    Package 用于管理一个或多个 Crate。创建一个 Package 的方式是使用 cargo new
    当我们输入命令时，Cargo 创建了一个目录以及一个 Cargo.toml 文件，这就是一个 Package。
    默认情况下，src/main.rs 是与 Package 同名的二进制 Crate 的入口文件，因此我们可以说我们现在有一个 my-project Package 以及一个二进制 my-project Crate。
    同样，如果在创建 Package 的时候带上 --lib，那么 src/lib.rs 将是它的 Crate 入口文件，且它是一个库 Crate
    如果我们的 src 目录中同时包含 main.rs 和 lib.rs，那么我们将在这个 Package 中同时得到一个二进制 Crate 和一个库 Crate，这在开发一些基础库时非常有用，
    例如你使用 Rust 中实现了一个 MD5 函数，你既希望这个 MD5 函数能作为库被别人引用，又希望你能获得一个可以进行 MD5 计算的命令行工具：那就同时添加 main.rs 和 lib.rs
  Crate
    Crate 是 Rust 的最小编译单元，即 Rust 编译器是以 Crate 为最小单元进行编译的。
    Crate 在一个范围内将相关的功能组合在一起，并最终通过编译生成一个二进制或库文件。
    例如，在项目中就使用了 rand 依赖，这个 rand 就是一个 Crate，并且是一个库的 Crate
  模块
    Module 允许我们将一个 Crate 中的代码组织成独立的代码块，以便于增强可读性和代码复用。
    同时，Module 还控制代码的可见性，即将代码分为公开代码和私有代码。
    公开代码可以在项目外被使用，私有代码则只有项目内部的代码才可以访问。定义一个模块最基本的方式是使用 mod 关键字
      mod mod1 {
        pub mod mod2{
          pub fn xxx()
          pub const MESSAGE: &str = "xxx";
        }
      }
      println!(mod1::mod2::MESSAGE);

  可见性
    Rust 中模块内部的代码，结构体，函数等类型默认是私有的，但是可以通过 pub 关键字来改变它们的可见性。通过选择性的对外可见来隐藏模块内部的实现细节
    pub：成员对模块可见
    pub（self）：成员对模块内的子模块可见
    pub（crate）：成员对整个 crate 可见

    mod mod1 {
        pub const MESSAGE: &str = "Hello World!";
        const NUMBER: u32 = 42;

        // pub(self)其实加不加没有影响，本来子模块就可以访问，所以更多是用来给开发者看的
        pub(self) fn mod1_pub_self_fn() {   
            println!("{}", NUMBER);
        }

        pub(crate) enum CrateEnum {
            Item = 4,
        }

        pub mod mod2 {
            pub const MESSAGE: &str = "Hello World!";

            pub fn mod2_fn() {
                super::mod1_pub_self_fn();
            }
        }
    }

    fn main() {
        println!("{}", mod1::MESSAGE);
        println!("{}", mod1::mod2::MESSAGE);
        mod1::mod2::mod2_fn();
        println!("{}", mod1::CrateEnum::Item as u32);
    }
  
  use绑定模块成员
    use std::fs;
    let data = fs::read("src/main.rs").unwrap();
    println!("{}", String::from_utf8(data).unwrap());

    可以使用 as 关键字将导入绑定到一个其他名称，它通常用在有多个不同模块都定义了相同名字的成员时使用
      use std::fs as stdfs;
      let data = stdfs::read("src/main.rs").unwrap();
      println!("{}", String::from_utf8(data).unwrap());
  
  使用super与self简化模块路径
    super：上层模块
    self：当前模块

    fn function() {
        println!("function");
    }

    pub mod mod1 {
        pub fn function() {
            super::function();
        }

        pub mod mod2 {
            fn function() {
                println!("mod1::mod2::function");
            }

            pub fn call() {
                self::function();
            }
        }
    }

    fn main() {
        mod1::function();
        mod1::mod2::call();
    }
  
  项目目录层次结构
    mod1.rs
      pub const MESSAGE: &str = "Hello World!";
    main.rs
      mod mod1;

      fn main() {
          println!("{}", mod1::MESSAGE);
      }
    
    将模块映射到文件夹
      当一个文件夹中包含 mod.rs 文件时，该文件夹可以被作为一个模块
      如果该文件夹下有其他模块可以在mod.rs中引用，那外部就可以通过mod.rs使用到

变量命名
  默认应该使用snake_case
  如果就是要驼峰则可以在文件中写入
  #![allow(non_snake_case)]

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
    {:#?} pretty print
  
  结构体的可见性
    结构体中的字段和方法默认是私有的，通过加上 pub 修饰语可使得结构体中的字段和方法可以在定义结构体的模块之外被访问。
    要注意，与结构体同一个模块的代码访问结构体中的字段和方法并不要求该字段是可见的
      mod mod1 {
          pub struct Person {
              pub name: String,
              nickname: String,
          }

          impl Person {
              pub fn new(name: &str, nickname: &str) -> Self {
                  Person {
                      name: String::from(name),
                      nickname: String::from(nickname),
                  }
              }

              pub fn say_nick_name(&self) {
                  println!("{}", self.nickname);
              }
          }
      }

      fn main() {
          let p = mod1::Person::new("jack", "baby");
          println!("{}", p.name);
          // println!("{}", p.nickname); // 不能访问 nickname
          p.say_nick_name();
      }

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

泛型
  泛型作为函数参数的类型
    fn largest<T: std::cmp::PartialOrd>(a: T, b: T) -> T {
        if a > b {
            a
        } else {
            b
        }
    }

    fn main() {
        println!("{}", largest::<u32>(1, 2));
        println!("{}", largest::<f32>(1.0, 2.1));
    }
    std::cmp::PartialOrd 被称作泛型绑定

  结构体中的泛型
    struct Point<T> {
        x: T,
        y: T,
    }

    fn main() {
        let integer = Point { x: 5, y: 10 };
        let float = Point { x: 1.0, y: 4.0 };
    }

    一个结构体中也可以包含多个不同的泛型参数
      struct Point<T, U> {
          x: T,
          y: T,
          z: U,
      }

      fn main() {
          let integer = Point { x: 5, y: 10, z: 15.0 };
          let float = Point { x: 1.0, y: 4.0, z: 8 };
      }
      虽然一个结构体中可以包含任意多的泛型参数,仍然建议拆分结构体以使得一个结构体中只使用一个泛型参数。过多的泛型参数会使得阅读代码的人难以阅读

  结构体泛型的实现
    struct Point<T> {
        x: T,
        y: T,
    }

    impl<T> Point<T> {
        fn x(&self) -> &T {
            &self.x
        }
    }

    fn main() {
        let p = Point { x: 5, y: 10 };

        println!("p.x = {}", p.x());
    }

    也可以在某种具体类型上实现某种方法，例如下面的方法将只在 Point<f32> 有效
      impl Point<f32> {
          fn distance_from_origin(&self) -> f32 {
              (self.x.powi(2) + self.y.powi(2)).sqrt()
          }
      }
  
  trait
    traits定义共同的行为
      pub trait Display {
          pub fn fmt(&self, f: &mut Formatter<'_>) -> Result<(), Error>;
      }

      use std::fmt;

      struct Point {
          x: i32,
          y: i32,
      }

      impl fmt::Display for Point {
          fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
              write!(f, "({}, {})", self.x, self.y)
          }
      }

      let origin = Point { x: 0, y: 0 };

      assert_eq!(format!("The origin is: {}", origin), "The origin is: (0, 0)");

    使用 Traits 作为参数类型
      与 Java 中的接口概念类似，也就是所谓的鸭子类型
        pub fn display(item: &impl std::fmt::Display) {
            println!("My display item is {}", item);
        }
        item 的参数类型是 impl std::fmt::Display 而不是某个具体的类型（例如 Point），这样，任何实现了 Display Traits 的数据类型都可以作为参数传入该函数

    自动派生
      自动派生有一个前提是，该结构体中全部字段都实现了指定的 Trait

      Debug Trait 允许将数据结构使用 {:?} 格式进行格式化
        #[derive(Debug)]
        struct Point {
            x: i32,
            y: i32,
        }

        fn main() {
            let p = Point { x: 1, y: 2 };
            println!("{:?}", p);
        }
      
      Trait：PartialEq。该特征允许两个数据使用 == 进行比较
        #[derive(Debug, PartialEq)]
        struct Point {
            x: i32,
            y: i32,
        }

        fn main() {
            let p1 = Point { x: 1, y: 2 };
            let p2 = Point { x: 1, y: 2 };
            println!("{}", p1 == p2);
        }

      Default Trait 会给结构体生成一个default的构造方法，生成出来的对象下的所有字段都会给他们类型的默认值
        #[derive(Debug, PartialEq，Default)]
        struct Point {
            x: i32,
            y: i32,
        }

        fn main() {
            let p = Point::default();
            println!("{:?}", p);
        }

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
      
    函数中传两个trait参数
      fn sum<T: Prods, U: Prods>(p1: T, p2: U) {
          println!("商品总价是:{}", p1.get_price() + p2.get_price());
      }

    一个struct对应多个trait 
      第一种
        fn show_detail<T:Prods+Stock>(p:T) {
          println!("商品的库存是:{}",p.get_stock());
        } 
      第二种
        fn show_detail<T>(p:T) 
        where T:Prods+Stock{
          println!("商品的库存是:{}",p.get_stock());
        } 
      
    重载操作符
      impl std::ops::Add<Book> for Book {
          // add code here
          type Output=f32;
          fn add(self, rhs: Book) -> f32{
              self.get_price()+rhs.get_price()
          }
      }

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
    name就是“shenyi所有者
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

  生命周期
    &str它的本质是 str。而且是被保存在“二进制文件中的”,使用时使用引用的方式来借用他
    static生命周期贯穿于整个程序,因此严格来讲叫做静态生存期

所有权
  所有权
    Rust 中每个值都绑定有一个变量, 称为该值的所有者. 
    每个值只有一个所有者, 而且每个值都有它的作用域. 
    一旦当这个值离开作用域, 这个值占用的内存将被回收

    fn main() {
        let s1 = String::from("any string");
        let s2 = s1;
        println!("{}", s1); // 报错,所有权已经转移给s2
    }

    fn main() {
        let s2: String;
        {
            let s1 = String::from("any string");
            s2 = s1;
            
        }
        println!("{}", s2); // 可以正常打印,因为所有权已经转移并且s2作用域在main函数中,所以可以打印 
    }

  引用
    fn reverse_string(s: String) -> String {
        s.chars().rev().collect()
    }

    fn main() {
        let s1 = String::from("any string");
        let s2 = reverse_string(s1);
        println!("{} {}", s1, s2);
    }
    编译错误，所有权已经被转移
    使用引用
      fn reverse_string(s: &String) -> String {
          s.chars().rev().collect()
      }

      fn main() {
          let s1 = String::from("any string");
          let s2 = reverse_string(&s1);
          println!("{} {}", s1, s2);
      }
    
    所有不可变变量的引用也都是不可变引用
    如果想声明可变引用,加上mut声明, mut 的位置在取地址符之后, 变量名之前
      fn append_string(s: &mut String) {
          s.push_str("!");
      }

      fn main() {
          let mut s = String::from("any string");
          append_string(&mut s);
          println!("{}", s);
      }
    
    对于可变引用来说, 任何变量一次只能有一个可变引用
    如果一个变量允许两个及以上的引用, 可能会存在数据竞争问题
    Rust 试图在编译器层面禁止这种 Bug 出现
      fn main() {
          let s = String::from("Hello World!");
          let s1_ref = &mut s;
          let s2_ref = &mut s; // cannot borrow as mutable
      }
  
  结构体变量声明与绑定，所有权，借用，引用
    fn main() {    
      struct Xxx{        
        a:i32,        
        b:i16,        
        c:bool,   
      }    
      //这是绑定的意思，将100这个值创建出来，然后将x1这个名称绑定到这个值上    
      let x1:i32 = 100;    
      //这也是绑定的意思，将Xxx这个结构体创建出来，然后将x2的名称绑定到这个x2上。    
      let x2 = Xxx{a:14, b:15, c:false};   
      //这里将从x1拷贝一份新的，然后将y1绑定到这份新的上    
      let mut y1:i32 = x1;   
      //将x2所对应结构体的所有权转让给y2，之后x2就不能再使用了    
      let mut y2 = x2;    
      //用&表示借用，意思是借用下这个内容，可以读取，但是不能修改。    
      //let z1 = &y1;    
      //let z2 = &y2;    
      //&mut 表示引用，引用就可以修改所引用的值得内容了，但是指导引用者被析构才会归还所有权，引用过程中被引用这不具有所有权。    
      let a1 = &mut y1;    
      let a2 = &mut y2;
    }
  所有系统默认有的变量类型
  有符号整数: i8, i16, i32, i64 和isize (指针大小)
  无符号整数: u8, u16, u32, u64 和 usize (指针大小)
  浮点: f32, f64
  char Unicode标值一样 ‘a’, ‘α’ 和 ‘∞’ (每4字节)
  bool 以及 true 或 false
  这些类型，在=的过程中，都使用的是拷贝（其实是语言内部实现了copy），而其他的自定义的类型，如struct在未实现copy前，都是转移所有权的意思。
  而数组和元组，是根据其变量的类型决定到底是copy还是转移所有权

  生命周期注解
    生命周期参数名称必须以撇号 ' 开头，其名称通常全是小写，类似于泛型其名称非常短。 
    'a 是大多数人默认使用的名称。生命周期参数注解位于引用的 & 之后，并有一个空格来将引用类型与生命周期注解分隔开

    // 由于返回的值可能是str1或str2编译器又无法自动推到所以需要通过注解标明
    // 要注意的是，生命周期注解并不改变任何引用的生命周期的长短
    fn bigger<'a>(str1: &'a str, str2: &'a str) -> &'a str {
        if str1 > str2 {
            str1
        } else {
            str2
        }
    }

    fn main() {
        println!("{}", bigger("a", "b"));
    }

    struct Person<'a> {
        name: &'a str,
    }

    fn main() {
        let p = Person {name: "Jack"};
        println!("{}", p.name);
    }
  
  静态生命周期
    具有静态生命周期的引用在整个程序运行期间一直存在。它使用 static 关键字
    具有静态生命周期的对象容易与常量搞混淆，虽然两者都在整个程序运行之中存在，但它们的区别是静态生命周期的对象有且只有一个内存地址，而常量则不一定

    字符串的内容 “Hello World!” 的作用域是函数体，而函数却试图返回它的引用。为了解决这个问题，需要将 &str 修改为 &'static str，它表明其所引用的内容的生命周期是整个程序运行期间
    fn hello_world() -> &'static str {
        return "Hello World!";
    }

    何时应该使用静态生命周期：
      正在存储大量数据
      静态对象的单地址属性是必需的
      内部可变性是必需的（静态对象是允许可变的）

      static mut LEVELS: u32 = 0;

      fn main() {
          // 因为 static mut 允许多线程进行修改
          // 所以对 static mut 的修改必须放置在 unsafe 块中
          unsafe {
              println!("{}", LEVELS);
              LEVELS += 1;
              println!("{}", LEVELS);
          }
      }

错误处理机制
  不可恢复的错误
    使用 panic! 宏是创建不可恢复的错误最简便的用法
      panic!("error!");
    断言
      assert!(1 == 2);
      assert_eq!(1, 2);
    未实现的代码
      fn add(a: u32, b: u32) -> u32 {
          unimplemented!()
      }
    不应当被访问的代码
      fn divide_by_three(x: u32) -> u32 { // one of the poorest implementations of x/3
          for i in 0.. {
              if 3*i < i { panic!("u32 overflow"); }
              if x < 3*i { return i-1; }
          }
          unreachable!();
      }
  
  可恢复的错误
    Result<T, E> 是一个带泛型的枚举
      enum Result<T, E> {
        Ok(T),
        Err(E),
      }
    Result<T, E> 通常用于函数的返回值，用以表明该次函数调用是成功或失败。它描述了函数调用过程可能出现的错误
    OK(T)：成功，并且获取到 T
    Err(E)：错误，并且获取到错误描述 E

    fn main() {
        match std::fs::read("/tmp/foo") {
            Ok(data) => println!("{:?}", data),
            Err(err) => println!("{:?}", err),
        }
    }
  
  自定义错误与问号表达式
    许多时候，尤其是在我们编写库的时候，不仅仅希望获取错误，更希望错误可以在上下文中的进行传递
    当函数的错误类型与当前错误的类型相同时，使用 ? 可以直接将错误传递到函数外并终止函数执行
    ? 的作用是将 Result 枚举的正常的值直接取出，如果有错误就将错误返回出去。
      fn foo() -> Result<T, E> {
          let x = bar()?; // bar 的错误类型需要与 foo 的错误类型相同
          ...
      }
    
    创建自定义的错误
      #[derive(Debug, PartialEq, Clone, Copy, Eq)]
      pub enum Error {
          IO(std::io::ErrorKind),
      }

      impl From<std::io::Error> for Error {
          fn from(error: std::io::Error) -> Self {
              Error::IO(error.kind())
          }
      }

      fn do_read_file() -> Result<(), Error>{
          let data =  std::fs::read("/tmp/foo")?;
          let data_str = std::str::from_utf8(&data).unwrap();
          println!("{}", data_str);
          Ok(())
      }

      fn main() {
          do_read_file().unwrap();
      }

智能指针Box
  Box 允许将一个值放在堆上而不是栈上，留在栈上的则是指向堆数据的指针。Box 是一个指向堆的智能指针，当一个 Box 超出作用域时，它的析构函数被调用，内部对象被销毁，堆上的内存被释放
    fn main() {
        let b = Box::new(5);
        println!("b = {}", b);
    }
  
  Box 没有运行上的性能损失，虽然如此，但它却只在以下场景中比起默认的栈上分配更适用：
    当有一个在编译时未知大小的类型，而又想要在需要确切大小的上下文中使用这个类型值的时候
    例如递归的类型，自己可以包含自己
    ConsList 每一项包含两个元素：当前项和下一项，若为Nil则是结束项
    ConsList(0, ConsList(1, ConsList(2, Nil)))

    enum List {
        Cons(i32, Box<List>),
        Nil,
    }

    fn example1() {
        let list = List::Cons(0, Box::new(List::Cons(1, Box::new(List::Cons(2, Box::new(List::Nil))))));
    }
  
  有大量数据并希望在确保数据不被拷贝的情况下转移所有权的时候
    fn example2() {
        let a = [0; 1024 * 512];
        let a_box = Box::new(a);
        // 这两种写法等价，都会先在栈上分配数据，然后再拷贝数据到堆上，不过后面再转移所有权时不会再拷贝数据，只会转移地址
        let a_box2 = Box::new([0; 1024 * 512]);
    }
  
  当希望拥有一个值并只关心它的类型是否实现了特定 trait 而不是其具体类型的时候
    fn example3() -> Result<(), Box<dyn std::error::Error>>{
        let f = std::fs::read("/tmp/not_exist")?;
        Ok(())
    }

引用计数Rc
  带引用计数的智能指针。只有当它的引用计数为 0 时，数据才会被清理
  ConsList 场景，如果多个节点共享一个节点
  0 -> 1 \
          |-> 4
  2 -> 3 /
  节点 4 它所拥有的值会有多个所有者，这个时候就需要使用 Rc 来进行包装
    use std::rc::Rc;

    enum List2 {
        Cons(i32, Rc<List2>),
        Nil,
    }

    fn rc_example() {
        // 通过Rc可以实现一个值可以有多个所有者
        let four = Rc::new(List2::Cons(4, Rc::new(List2::Nil)));
        // 调用 clone 时，Rc的引用计数会加一
        let zero_one = List2::Cons(0, Rc::new(List2::Cons(1, four.clone())));
        // 另一种等价写法
        // let zero_one = List2::Cons(0, Rc::new(List2::Cons(1, Rc::clone(&four))));
        let two_three = List2::Cons(2, Rc::new(List2::Cons(3, four)));
    }

Vector动态数组
  vector 是动态大小的数组。与切片一样，它们的大小在编译时是未知的，但它们可以随时增长或收缩，向量使用 3 个参数表示：
    指向数据的指针
    长度
    容量
  量表示为向量预留了多少内存。 一旦长度大于容量，向量将申请更大的内存进行重新分配

  fn main() {
      let mut v: Vec<i32> = Vec::new();
      v.push(1);
      println!("{:?}", v[0]);
    
    // 通过宏创建Vector的写法
      let v2: Vec<i32> = vec![0, 1, 2, 3, 4, 5];
      println!("{:?}", v2[2]);
    
    // 修改Vector内的元素值
      for e in v.iter_mut() {
          *e *= 2;
      }
  }

HashMap
  HashMap 是一种从 Key 映射到 Value 的数据结构。与 Vector 一样，HashMap 也是可以动态调整大小的
  大多数数据类型都可以作为 HashMap 的 Key，只要它们实现了 Eq 和 Hash traits

  use std::collections::HashMap;

  fn main() {
      let map = HashMap::new();
      map.insert("key", "value");
      println!("{:?}", map.get(&"key"));
      map.remove(&"key");

      match map.get(&"key") {
        Some(data) => println!("{:?}", data),
        None => println!("not found"),
      }
      
      for (&k, &v) in map.iter() {
        println!("{:?} {:?}", k, v);
      }
  }

SystemTime
  use std::thread::sleep;
  use std::time::{Duration, SystemTime};

  fn main() {
      // 获取当前时间
      let mut now = SystemTime::now();
      println!("{:?}", now);

      // 获取 UNIX TIMESTAMP
      let timestamp = now.duration_since(SystemTime::UNIX_EPOCH);
      println!("{:?}", timestamp);

      sleep(Duration::from_secs(4));

      // 获取流逝的时间
      println!("{:?}", now.elapsed());

      // 时刻的增减
      now.checked_add(Duration::from_secs(60))
  }

宏
  macro_rules! echo {
      () => (
          println!("shenyi");
      )
  }

  带参数的宏
    macro_rules! echo {
        () => (
            println!("shenyi");
        );
        ($exp:expr) => (
            println!("{}",stringify!($exp));
        );
        // 可变参数
        ($($exp:expr),+) => (
            $(
                println!("{}",stringify!($exp));     
            )+
        );
    }
  
  利用宏自定义函数
    macro_rules! func {
        ($fn_name:ident) => {
            fn $fn_name(){
                println!("my function,name is :{}",stringify!($fn_name));
            }
        };
    }

    func!(php);
    php();