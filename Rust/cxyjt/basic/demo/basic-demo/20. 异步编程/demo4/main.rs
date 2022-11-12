use tokio::time::{timeout,delay_for, Duration};
use tokio::net::TcpListener;
use tokio::prelude::*;

#[tokio::main] 
async fn main(){
      let mut server=TcpListener::bind("0.0.0.0:8080").await.unwrap();
      loop{
            let (mut stream,_)=server.accept().await.unwrap();
            let rsp=String::from("HTTP/1.1 200 OK\r\n\r\nrust server");
            stream.write_all(rsp.as_bytes()).await.unwrap();
      }
}