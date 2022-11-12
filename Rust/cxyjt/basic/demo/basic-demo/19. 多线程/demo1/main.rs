use std::thread;
use std::time::Duration;
 
fn main() {
    
    let t=thread::spawn(||{
        for i in 0..5{
            println!("{}",i);
            thread::sleep(Duration::from_millis(500));
        }
    });
 
    let t2=thread::spawn(|| {
        println!("{}","shenyi");
    });
   t2.join().unwrap();
   t.join().unwrap();
}
