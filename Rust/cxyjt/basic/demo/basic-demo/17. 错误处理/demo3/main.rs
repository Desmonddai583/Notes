 
 fn step1()->Result<String,String>{
     Ok("err1".to_string())
 }
 fn step2()->Result<String,String>{
    Err("err2".to_string())
}
 fn test()->Result<String,String>{
       step1()?;
       step2()?;
       Ok("done".to_string())
 }
fn main() {
    let ret=test();
    println!("{}",ret.unwrap_or_else(|error|{
        error
    }));
    
}
