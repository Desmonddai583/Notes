use std::thread;
use std::time::Duration;
use futures::executor::block_on;

async fn getscore()->i32{
    100
}
async fn getuser() ->String{
    
    thread::sleep(Duration::from_secs(2));
    format!("user is {},score is {}","shenyi",getscore().await)
}
fn main() {
 
    let ret=block_on(getuser());
    println!("{}",ret);
    println!("{}","done");
   
}
