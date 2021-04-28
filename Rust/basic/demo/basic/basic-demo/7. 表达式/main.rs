fn get_user(uid:i32)->&'static str{
    let ret = if  uid==101{
        "shenyi"  
    }else if uid==102{
         "zhangsan" 
    }else {
     "unknown"  
    };
    ret
  
} 
 
 
 
fn main() {
    let uid=101;
     println!("{}",get_user(uid));
  
      
   
     

}


