use serde::{Serialize};
use std::io::Cursor;
use rocket::request::Request;
use rocket::response::{self, Response, Responder};
use rocket::http::ContentType;

pub struct Json<T>(pub T);
impl<'a,T:Serialize> Responder<'a> for Json<T> {
    fn respond_to(self, _: &Request) -> response::Result<'a> {
        let json=serde_json::to_string(&self.0).unwrap();
        Response::build()
            .sized_body(Cursor::new(json))
            .header(ContentType::new("application", "json"))  
            .ok()
    }
}