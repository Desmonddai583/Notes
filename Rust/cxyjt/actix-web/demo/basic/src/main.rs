use actix_web::{HttpServer, App, Responder,get, HttpResponse,HttpRequest, web, post, dev::Service, http::header::{self, HeaderName, HeaderValue}};
 
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
 
use qstring::QString;
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
#[get("/")]
async fn index(req:HttpRequest)->impl Responder{
    HttpResponse::Ok().body("index")
}
#[get("/users")]
async fn users_list(req:HttpRequest)->impl Responder{
    HttpResponse::Ok().body("users")
}
 
//本课程来自 程序员在囧途(www.jtthink.com) 咨询群：98514334
#[actix_web::main]
 async fn main() ->std::io::Result<()> {
    
    HttpServer::new(||{
        App::new().wrap_fn(|req,svc|{
            let call_ret= svc.call(req);
            async{
               
                let mut rsp=call_ret.await?; //响应
                rsp.headers_mut().insert(HeaderName::from_static("myname"),
                 HeaderValue::from_static("shenyi"));
                Ok(rsp)
            }
        }).
        service(index).
        service(users).
        service(users_list)

    }).bind(("0.0.0.0",8080))?.run().await
}
