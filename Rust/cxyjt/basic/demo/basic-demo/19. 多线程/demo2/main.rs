use std::thread;
use std::time::Duration;
use std::sync::mpsc;
fn main() {

    let (tx,rx)=mpsc::channel();
     thread::spawn(move ||{
        for i in 0..5{
            thread::sleep(Duration::from_millis(500));
            tx.send(i).unwrap()
        }
    });
    for ret in rx{
        println!("{}",ret);
    }

    // while true{
    //     let ret=rx.recv();
    //     if let Ok(i)=ret{
    //         println!("{}",i);
    //     }else{
    //         println!("done");
    //         break;
    //     }
    // }
  
 
}
