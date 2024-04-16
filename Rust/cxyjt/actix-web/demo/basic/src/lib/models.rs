use std::string;

// 存放响应模型 ，，实现 trait Responder
use actix_web::{HttpServer, App, Responder,get, HttpResponse,HttpRequest, web, post, dev::Service, http::{header::{self, HeaderName, HeaderValue}, StatusCode}, body::BoxBody};
#[derive(serde::Deserialize,serde::Serialize,Debug)]
pub struct  UserModel {
    pub id:i32,
    pub name:String
}
impl Responder for UserModel {
    type Body=BoxBody;

    fn respond_to(self, req: &HttpRequest) -> HttpResponse<Self::Body> {
      let json_str=serde_json::to_string(&self).unwrap();
      HttpResponse::Ok().insert_header(("Content-type","application/json")).body(json_str)

    }
}