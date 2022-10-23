fn get_user(uid:i32){
    if uid==101{
        println!("user is :{}","shenyi");
    }else if uid==102{
        println!("user is :{}","zhangsan");
    }else {
        println!("user is :{}","unknown");
    }
} 
fn main() {
    let uid=101;
 get_user(uid);
}


