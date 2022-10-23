mod api;
mod models;
// use api::Prods;
// use models::*;
 
 
#[derive(Debug)]
struct User<'a> {
    id: &'a i32
}
 
fn main() {
    let mut id=109; //好比是我的汽车
   let u=User{id:&id};  // 车被user借走了
   
   id=108; //不能用
   println!("{:?}",u); //还没还

}
