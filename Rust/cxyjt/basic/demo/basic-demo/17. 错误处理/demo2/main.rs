 
 fn test(i:i32)->Result<String,i32>{
    if i<10{
        Ok(String::from("success"))
    }else{
        Err(0)
    }
    
 }
fn main() {
    let ret=test(33);
    println!("{}",ret.unwrap_or_else(|error|{
        (error+1).to_string()
    }));
}
