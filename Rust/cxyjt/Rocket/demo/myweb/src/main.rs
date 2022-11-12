#![feature(proc_macro_hygiene, decl_macro)]
#[macro_use] extern crate rocket;
 mod models;
//  mod lib;
 use models::UserModel;
//  use lib::Json;
 use rocket_contrib::json::Json;
  
#[get("/users?<page>&<size>")]
fn users(page:Option<i32>,size:Option<i32>)->String{
    let get_page=page.unwrap_or(1);
    let get_size=size.unwrap_or(10);
    format!("用户列表,page:{},size:{}",get_page,get_size)
}

#[get("/users/<uid>",rank=1)]
fn users_detail_int(uid:i32)->Json<UserModel<i32>>{
    Json(UserModel{user_id:uid,user_name:String::from("test")})
}
#[get("/users/<uid>",rank=2)]
fn users_detail_str(uid:String)-> Json<UserModel<String>>{
    Json(UserModel{user_id:uid,user_name:String::from("string userid")})
}
#[post("/users",format="json",data="<user>")]
fn users_post(user:Json<UserModel<i32>>)-> Json<UserModel<i32>>{
     println!("{},{}",user.user_name,user.user_id);
     user
}
 
fn main() {
    let server=rocket::ignite();
    server.mount("/", routes![users,users_detail_int
    ,users_detail_str,users_post]).launch();
}
