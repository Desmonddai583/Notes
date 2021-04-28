mod api;
mod models;
// use api::Prods;
// use models::*;

// fn show_name<'a>(name: &'a str) -> &'a str {
//     name
// }

#[derive(Debug)]
enum Sex { 
    Male(String,u8),
    Female(String)  
}
 
#[derive(Debug)]
struct User {
    id: i32,
    sex:Option<String>,
}

fn check(u:User){
    println!("{}",u.sex.unwrap());
//    if let Some(s) = u.sex{
//        println!("{}",s);
//    }
}
use Sex::Male;
fn main() {
  
    let u = User {
        id: 101,
        sex:  Some(String::from("M")),
    };
    check(u);
  
}
