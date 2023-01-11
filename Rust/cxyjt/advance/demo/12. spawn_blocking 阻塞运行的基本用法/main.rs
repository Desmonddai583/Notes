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
 #[tokio::main(flavor="current_thread")]
 async fn main() {

    let h1=task::spawn( async {
        sleep(Duration::from_secs(5)).await; 
         println!("{}","h1已经完成了");
        "h1"
    });
    // 本课程来自 程序员在囧途(www.jtthink.com) 咨询群：98514334

    let h2=task::spawn( async {
        sleep(Duration::from_secs(2)).await; 
         println!("{}","h2已经完成了");
        "h2"
    });

   
    let h3=task::spawn_blocking( || {
  
        std::thread::sleep(Duration::from_secs(8));
      
         println!("{}","h3已经完成了");
        "h3"
    });
    
          h1.await.unwrap();
      
          h2.await.unwrap();

          h3.await.unwrap();
 
  // 本课程来自 程序员在囧途(www.jtthink.com) 咨询群：98514334
//         let handler=tokio::runtime::Handle::current();

 
   
//        let h1= handler.spawn(job(123));
//        let h2= handler.spawn(job(234));
//        let h3= handler.spawn(job(456));
//         let  start_time=Utc::now().time();

     
//             let r1=h1.await.unwrap();
//             let r2=h2.await.unwrap();
//             let r3=h3.await.unwrap();
//             println!("执行结果是:{},{},{}",r1,r2,r3);
       
//         let  end_time=Utc::now().time();
//         println!("耗时:{}",(end_time-start_time).num_milliseconds());
// }
// 本课程来自 程序员在囧途(www.jtthink.com) 咨询群：98514334

 }
 