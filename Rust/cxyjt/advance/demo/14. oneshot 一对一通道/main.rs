#![feature(exclusive_range_pattern)]
#![feature(is_some_with)]
#![allow(dead_code)]

 
 use std::future::Future;
use std::str::FromStr;
use std::sync::Arc;

use tokio::time;
use tokio::time::*;

async fn job(i:i32)->i32{
    sleep(Duration::from_secs(2)).await; //延迟2秒
    i 
}
use chrono::Utc;
 
// 本课程来自 程序员在囧途(www.jtthink.com) 咨询群：98514334
use tokio::runtime::*;
 
 
 use tokio::task;
 use tokio::sync::oneshot;
 // 本课程来自 程序员在囧途(www.jtthink.com) 咨询群：98514334
 #[tokio::main]
 async fn main() {
         let (tx,rx)=oneshot::channel();

      task::spawn(async { //发送方
            time::sleep(Duration::from_secs(2)).await;
            tx.send(123).unwrap();
         
     });
     
     let ret=rx.await.unwrap();
 
     println!("{}",ret);

// 本课程来自 程序员在囧途(www.jtthink.com) 咨询群：98514334

 }
 