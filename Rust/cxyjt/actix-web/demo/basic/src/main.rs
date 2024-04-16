use actix_web::{HttpServer, App, Responder,get, HttpResponse,HttpRequest, web, post, dev::Service, http::{header::{self, HeaderName, HeaderValue}, StatusCode}};
 use lib::mysql::*;
#[derive(serde::Deserialize,Debug)]
struct  IndexParam {
    #[serde(default)]
    id:i32,
    #[serde(default="default_name")]
    name:String
 }
 fn default_name()->String{
    "guest".to_string()
 }

 use regex::Regex;
 use once_cell::sync::Lazy;
 static  USERNAME_REG:Lazy<Regex>=Lazy::new(|| {
    Regex::new(r"^[a-z]{4,20}$").unwrap()
 });
  

 //本课程来自 程序员在囧途(www.jtthink.com) 咨询群：98514334
 use validator::{Validate};
 #[derive(serde::Deserialize,serde::Serialize,Debug,Validate)]
struct UserModel{
        #[serde(skip_deserializing)]
        user_id:i32,
        //#[validate(length(min=4,message="用户名必须大于4长度"))]
        #[validate(regex(path="USERNAME_REG",message="用户名必须是小写字母,长度4-20"))]
        user_name:String,

        #[validate(range(min=1,max=100,message="年龄必须是1-100岁之间"))]
        user_age:u8
 }
 

 
//本课程来自 程序员在囧途(www.jtthink.com) 咨询群：98514334
// 专注golang、k8s、RUst云原生技术栈
 

#[post("/users")]
async fn users(body:Option<web::Json<UserModel>>)->impl Responder{
    if let Some(user)=body{
        match user.validate(){
            Ok(_)=> return HttpResponse::Ok().json(user),
            Err(err)=> return HttpResponse::Ok().json(err)
        }
    }
    HttpResponse::BadRequest().body("参数不正确")
}
 
 
 
#[get("/shares")]  // 取出股票数据列表
async fn share_list()->impl Responder{
    let data=test_mysql().await.unwrap();
    web::Json(data)
   
}

//  GET /?token=xxx  
use lib::myrequest::TokenRequest;
#[get("/")]
async fn index(req:TokenRequest)->impl Responder{
    println!("{}",req.token);
    HttpResponse::Ok().body("index")
}
use lib::models::UserModel as UserReponse;
//本课程来自 程序员在囧途(www.jtthink.com) 咨询群：98514334
#[get("/users")]
async fn users_list(req:HttpRequest)->impl Responder{
    // HttpResponse::Ok().body("users")
    UserReponse{id:101,name:"lisi".to_string()}

}
#[get("/admin")] // 假设 管理员才能访问
async fn admin_index(req:HttpRequest)->impl Responder{
    HttpResponse::Ok().body("管理员才能访问的")
}

 mod lib;
 use lib::header::{AddHeader};
 use lib::auth::Auth;
 use actix_web::dev::ServiceResponse;
 use actix_web::middleware::ErrorHandlerResponse;
 use actix_web::middleware::ErrorHandlers;

 fn handler_401<B>(  res:ServiceResponse<B>) ->actix_web::Result<ErrorHandlerResponse<B>>{
   let get_err=res.response().error();
   let mut rsp_str="401".to_string();
   if let Some(e)=get_err{
       rsp_str=e.to_string();
   }
   let new_res=ServiceResponse::new(res.request().to_owned(),
   HttpResponse::Unauthorized().body(rsp_str));
   
    Ok(ErrorHandlerResponse::Response(new_res.map_into_right_body()))
 }
//本课程来自 程序员在囧途(www.jtthink.com) 咨询群：98514334
#[actix_web::main]
 async fn main() ->std::io::Result<()> {
    init_my_sql_pool().await;
    HttpServer::new(||{
        App::new().
        wrap(AddHeader{}).
        wrap(Auth{}).
        wrap(ErrorHandlers::new().handler(StatusCode::UNAUTHORIZED, handler_401)).
        service(admin_index).
        service(index).
        service(users).
        service(users_list)
        .service(share_list)
    }).bind(("0.0.0.0",8080))?.run().await
}
