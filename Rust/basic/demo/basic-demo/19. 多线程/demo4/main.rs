use std::thread;
use std::time::Duration;
use std::sync::{mpsc,Arc};
use std::rc::Rc;

fn curl(i:i32,tx:mpsc::Sender<String>){
    thread::sleep(Duration::from_secs(1));
    tx.send(format!("第{}个网页抓取完成",i)).unwrap();
} 
 
fn main() {
     let (tx,rx)=mpsc::channel();
    for i in 0..5{
        let clone_tx=tx.clone();
        thread::spawn(move ||{
             curl(i,clone_tx);
         });
    }
    thread::spawn(move ||tx.send(String::from("开始抓取")).unwrap());
    for ret in &rx{
         println!("{}",ret);   
    }
}
