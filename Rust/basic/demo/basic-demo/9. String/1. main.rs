fn main() {
    let name = String::from("abc");
    println!("ptr is : {:p}", name.as_ptr());
    let name2 = name;
    println!("ptr is : {:p}", name2.as_ptr());
}
