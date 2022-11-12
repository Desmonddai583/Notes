fn get_user(uid:i32)->&'static str{
    if uid==101{
        return "shenyi";
    }else if uid==102{
        return "zhangsan";
    }else {
       return "unknown";
    }
} 
 
fn main() {
    let uid=101;
     println!("{}",get_user(uid));
 
}


