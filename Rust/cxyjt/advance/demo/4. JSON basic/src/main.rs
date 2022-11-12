#![feature(exclusive_range_pattern)]

 
 mod lib;
 use lib::prelude::*;
 use lib::user::*;

 fn main() {
    
    //  let u=User::default();
    //  println!("{}", serde_json::to_string_pretty(&u).unwrap());
     // golang map[string]interface{}  gjson
    let user_str=r#"
    {
        "id": 0,
        "user_name": "guest",
        "friends":["shenyi","zhangsan"],
        "roles":[
             {"name":"admin"},
             {"name":"guest"}
        ]
      }
    "#;
    let user:serde_json::Value=serde_json::from_str(user_str).unwrap();
    println!("{}",user.as_object().and_then(|v| v.get("roles"))
    .and_then(|v| v.get(0)).and_then(|v| v.get("name")).unwrap());
}