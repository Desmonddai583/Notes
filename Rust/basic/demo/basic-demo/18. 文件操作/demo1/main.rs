 
use std::fs::File;
use std::io::prelude::*;
fn main() {
    
    let path="./src/test.txt";
    let mut f=File::open(path).expect("file err");
    let mut buf=String::new();
    f.read_to_string(&mut buf).expect("read err");

    println!("{}",buf);
}
