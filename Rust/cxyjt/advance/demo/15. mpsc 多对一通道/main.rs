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
 use tokio::sync::{oneshot,mpsc};
 // 本课程来自 程序员在囧途(www.jtthink.com) 咨询群：98514334
 #[tokio::main]
 async fn main() {
         
         let (tx,mut rx)=mpsc::channel(10);
         let tx1=tx.clone();
         let tx2=tx.clone();
         task::spawn(async move {
            let mut i=0;
            while i<10 {
                tx1.send(i).await.unwrap();
                i=i+1;
            }
         });

         task::spawn(async move {
            let mut i=10;
            while i<20 {
                tx2.send(i).await.unwrap();
                i=i+1;
            }
         });
         drop(tx);
         while let Some(ret)=rx.recv().await{
            println!("{}",ret);
         }
  
 
     

// 本课程来自 程序员在囧途(www.jtthink.com) 咨询群：98514334

 }
 