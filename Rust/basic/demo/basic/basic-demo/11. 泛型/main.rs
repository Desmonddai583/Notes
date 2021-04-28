mod models;
use models::user_model::UserInfo;
fn set_user(u:&mut  UserInfo){
     u.user_id=101;
     u.user_name=String::from("shenyi");
     u.user_age=19;
     u.user_tags=["java","php","js","golang","rust"];
}
 
fn main() {
    
    //  let mut user=models::user_model::new_user_info();
    //  set_user(&mut user);
    
     let mut user_score=models::user_model::new_user_score_b();
     user_score.user_id="#EFEF";
     user_score.score=10.0;
     println!("{:?}",user_score);
}  
