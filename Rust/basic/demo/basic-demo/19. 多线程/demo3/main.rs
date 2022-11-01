use std::thread;
use std::time::Duration;
use std::sync::mpsc;
fn main() {

    let (tx,rx):(mpsc::SyncSender<i32>,mpsc::Receiver<i32>)=
    mpsc::sync_channel(5);
 
     thread::spawn(move ||{
        for i in 0..5{
            thread::sleep(Duration::from_millis(500));
            tx.send(i).unwrap()
        }
    });
    thread::sleep(Duration::from_secs(3));
    for ret in rx{
        println!("{}",ret);
    }
}
