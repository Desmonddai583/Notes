use serde::{Serialize,Deserialize};

#[derive(Serialize,Deserialize)]
pub struct UserModel<T>{
    #[serde(rename(serialize = "userid", deserialize = "uid"))]
    pub user_id:T,
    pub user_name:String
}
// impl<'a> Responder<'a> for UserModel {
//     fn respond_to(self, _: &Request) -> response::Result<'a> {
//         let json=serde_json::to_string(&self).unwrap();
//         Response::build()
//             .sized_body(Cursor::new(json))
//             .header(ContentType::new("application", "json"))  
//             .ok()
//     }
// }

 