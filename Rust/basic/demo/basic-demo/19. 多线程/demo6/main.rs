use std::sync::{mpsc, Arc, Mutex};
use std::thread;
use std::time::Duration;
//use futures::executor::block_on;

fn main() {
    let share_num = Arc::new(Mutex::new(0));
    let mut pool = Vec::new();

    for _ in 0..5 {
        let share_num_thread = share_num.clone();
        pool.push(thread::spawn(move || {
            let mut num = share_num_thread.lock().unwrap();
            *num += 1;
        }))
    }
    for t in pool {
        t.join().unwrap();
    }
    println!("{:?}", share_num.lock().unwrap());
}
