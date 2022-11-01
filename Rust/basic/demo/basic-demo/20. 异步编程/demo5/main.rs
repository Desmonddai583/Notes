use tokio::time::{timeout,delay_for, Duration};
use tokio::net::TcpListener;
use tokio::prelude::*;
use tokio::task;
#[tokio::main] 
async fn main(){
         let mut server=TcpListener::bind("0.0.0.0:8080").await.unwrap();
         loop {
            let (mut stream,_)=server.accept().await.unwrap();
//Rocket Rust go . hyper
            task::spawn(async move{
                  let mut rsp=String::from("HTTP/1.1 200 OK\r\n\r\nrust server");
                  let ret=task::spawn_blocking(||{
                         "bloking"
                   }).await;
                   if let Ok(s)=ret{
                        rsp.push_str(s);
                   }

                  stream.write(rsp.as_bytes()).await.unwrap();
            });
         }
}