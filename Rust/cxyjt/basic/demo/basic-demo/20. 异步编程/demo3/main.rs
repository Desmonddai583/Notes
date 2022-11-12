use tokio::time::{timeout, Duration};
async fn job() -> String {
      String::from("abc")
}
#[tokio::main] 
async fn main(){
     
     let ret=timeout(Duration::from_secs(2),job()).await;
     print!("{}",ret.unwrap());
    
}