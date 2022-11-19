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

  fn maxstr<'a,'b>(a:&'a str,b:&'b str)->&'b str
  where
     'a:'b
  {
      if a.len()>=b.len(){
         return a;
      }
      b
  }
 
 
// 本课程来自 程序员在囧途(www.jtthink.com) 咨询群：98514334
 fn main() {
    let str1="shenyi";   // ------- 'a
    let str2="zhangsan";  ////------- 'b
    let str3=maxstr(str1, str2);  // -----'b ( 返回值)
   
    println!("{}",str3);   //  str3 str2 str1 死亡

 
 
}
// 本课程来自 程序员在囧途(www.jtthink.com) 咨询群：98514334

 
 