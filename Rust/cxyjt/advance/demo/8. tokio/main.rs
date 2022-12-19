#![feature(exclusive_range_pattern)]
#![feature(is_some_with)]
#![allow(dead_code)]

 
 use tokio::time::*;
async fn job(i:i32){
    sleep(Duration::from_secs(2)).await;
    println!("{}",i);
}
// 本课程来自 程序员在囧途(www.jtthink.com) 咨询群：98514334
 use tokio::runtime::*;
 fn main() {
   
        let rt=Builder::new_multi_thread().worker_threads(2)
        .enable_time().build().unwrap();

        rt.block_on( async {
            job(123).await
        });
        

}
// 本课程来自 程序员在囧途(www.jtthink.com) 咨询群：98514334

 
 