 
use std::{future::Future,};

use gloo_net::http::Request;
 //本课程来自 程序员在囧途(www.jtthink.com) 咨询群：98514334

pub trait UserTrait {
      fn get_name(self)->String;
}
pub enum TestMsg {
    TestClick,
    LoadUser,
    LoadUserDone(String)
   
}
 //本课程来自 程序员在囧途(www.jtthink.com) 咨询群：98514334

pub async fn get_user<T:serde::Serialize+serde::de::DeserializeOwned+Clone+PartialEq>()->Result<T,wasm_bindgen::JsValue>{
    let obj:T=Request::get(super::with_path("/test").as_str()).send().
    await.unwrap().json().await.unwrap();
    Ok(obj)
 }

  //本课程来自 程序员在囧途(www.jtthink.com) 咨询群：98514334

 // 把 future做了封装
pub fn get_user_future<T>()->impl Future<Output=TestMsg>+'static
where
 T:serde::Serialize+serde::de::DeserializeOwned+Clone+PartialEq+UserTrait
{
   let f= async{
        match get_user::<T>().await{
            Ok(user)=> TestMsg::LoadUserDone(user.get_name()),
            Err(_)=>TestMsg::LoadUserDone("nouser".to_string())
        }
    };
    return f;
}