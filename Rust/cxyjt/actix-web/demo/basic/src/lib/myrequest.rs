use actix_web::FromRequest;
pub struct  TokenRequest{

    pub token:String
}
use std::future::{Ready,ready};
use qstring::QString;
impl FromRequest for  TokenRequest{
    type Error=actix_web::Error;

    type Future=Ready<Result<Self, Self::Error>>;

    fn from_request(req: &actix_web::HttpRequest, _: &mut actix_web::dev::Payload) -> Self::Future {
        let q=QString::from(req.query_string());
        ready(Ok(TokenRequest{token:q.get("token").unwrap_or("").to_string()}))

    }
}