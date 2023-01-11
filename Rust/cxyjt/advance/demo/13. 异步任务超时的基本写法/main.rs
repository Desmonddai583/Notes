#![feature(exclusive_range_pattern)]
#![feature(is_some_with)]
#![allow(dead_code)]

 
 use tokio::time::*;

async fn job(i:i32)->i32{
    sleep(Duration::from_secs(2)).await; //延迟2秒
    i 
}
use chrono::Utc;
 
// 本课程来自 程序员在囧途(www.jtthink.com) 咨询群：98514334
use tokio::runtime::*;
 
 
 use tokio::task;
 // 本课程来自 程序员在囧途(www.jtthink.com) 咨询群：98514334
 #[tokio::main]
 async fn main() {

     
     let t1=tokio::time::timeout(Duration::from_secs(2), async {
        sleep(Duration::from_secs(3)).await;
        // println!("任务完成");
        panic!("内部报错了")
     });
     let h1=task::spawn(t1);
    h1.await.expect("内部任务出错").expect("超时出错");
 
    
     
    
  
 
// 本课程来自 程序员在囧途(www.jtthink.com) 咨询群：98514334

 }
 