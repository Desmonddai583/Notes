use serde::{Serialize, Deserialize,Serializer};
use serde::ser::SerializeStruct;
 #[derive(Debug,Clone)]
 pub struct User{
 
    pub id:i32,
   //  #[serde(rename(serialize = "user_name",deserialize="user_name"))]
    pub name: String,//guest
 
   //  #[serde(default="User::default_age")]
    pub age:i32 ,
   //  #[serde(default)]
    pub admin:bool
 }
 impl Serialize for User {
      fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
          where
              S: serde::Serializer {
               let mut s = serializer.serialize_struct("User", 4)?;
               s.serialize_field("user_id", &self.id)?;
               s.serialize_field("user_name", &self.name)?;
               s.end()

      }
 }


 impl  Default for User {
       fn default() -> Self {
           User{id:0,name:String::from("guest"),age:0,admin:false}
       }
 }
 impl User {
      fn default_age()->i32{
         28
      }
 }
 
 use std::fmt;
 impl fmt::Display  for User{
        fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
           write!(f, "用户ID是:{},用户年龄:{},用户名是{},是否管理员:{}", 
           self.id, self.age,self.name,self.admin)
         }
 }
 use super::prelude::*;
impl UserInit<i32> for User {
     fn new(id:i32)->Self{
        User{id:id,..Default::default()}
      }
}
impl UserInit<&str> for User {
    fn new(name:&str)->Self{
       User{name:name.to_string(),..Default::default()}
     }
}
 