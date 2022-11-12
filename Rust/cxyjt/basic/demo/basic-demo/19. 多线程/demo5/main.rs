use std::thread;
use std::time::Duration;
use std::sync::{mpsc,Arc};
use std::rc::Rc;

 
static mut N: i32 = 0;
fn main() {
    let mut pool=Vec::new();
    for _ in 0..15{
        pool.push(thread::spawn(||{
            unsafe {
                N=N+1; 
            }
         }));
    }
    for t in pool{
        t.join().unwrap();
    }
    unsafe{
        println!("{}",N);
    }

}
