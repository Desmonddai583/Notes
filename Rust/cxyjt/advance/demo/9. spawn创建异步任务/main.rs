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
 fn main() {
   
        let rt=Builder::new_multi_thread().worker_threads(2)
        .enable_time().build().unwrap();

       let h1= rt.spawn(job(123));
       let h2= rt.spawn(job(234));
       let h3= rt.spawn(job(456));
        let  start_time=Utc::now().time();

        rt.block_on(async {
            let r1=h1.await.unwrap();
            let r2=h2.await.unwrap();
            let r3=h3.await.unwrap();
            println!("执行结果是:{},{},{}",r1,r2,r3);
        });
     
        // rt.block_on( async {
        //     let r1=job(123).await;
        //     let r2=job(234).await;
        //     let r3=job(456).await;
        //     println!("执行结果是:{},{},{}",r1,r2,r3);
         
        // });
       
        let  end_time=Utc::now().time();
        println!("耗时:{}",(end_time-start_time).num_milliseconds());
}
// 本课程来自 程序员在囧途(www.jtthink.com) 咨询群：98514334

 
 