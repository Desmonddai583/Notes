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
 
 #[tokio::main(flavor = "multi_thread")]
 async fn main() {
        let handler=tokio::runtime::Handle::current();

       let h1= handler.spawn(job(123));
       let h2= handler.spawn(job(234));
       let h3= handler.spawn(job(456));
        let  start_time=Utc::now().time();

     
            let r1=h1.await.unwrap();
            let r2=h2.await.unwrap();
            let r3=h3.await.unwrap();
            println!("执行结果是:{},{},{}",r1,r2,r3);
       
        let  end_time=Utc::now().time();
        println!("耗时:{}",(end_time-start_time).num_milliseconds());
}
// 本课程来自 程序员在囧途(www.jtthink.com) 咨询群：98514334

 
 