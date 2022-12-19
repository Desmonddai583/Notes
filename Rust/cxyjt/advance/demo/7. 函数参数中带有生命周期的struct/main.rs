#![feature(exclusive_range_pattern)]
#![feature(is_some_with)]
#![allow(dead_code)]

use std::future::Future;

 
 
 mod lib;

 #[derive(Debug)]
 struct User<'a> {
    name:&'a String // 不能是尸体
  }
  impl<'a> User<'a>{
      fn get_name(&self)->&String{
         return &self.name;
      }
  }
 
// 本课程来自 程序员在囧途(www.jtthink.com) 咨询群：98514334
  fn maxstr<'a,'b:'a>(a:&'a str,b:&'b User)->&'a str
  {
      if a.len()>=b.get_name().len(){
         return a;
      }
      b.get_name().as_str()
  }
 
 
// 本课程来自 程序员在囧途(www.jtthink.com) 咨询群：98514334
 fn main() {
    let str1="shenyi";    
    let u=User{name:&String::from("zhangsan")};
   
    println!("{}", maxstr(str1,&u));   

 
 
}
// 本课程来自 程序员在囧途(www.jtthink.com) 咨询群：98514334

 
 