use yew::prelude::*;
use crate::helper::js;
 
 // 移走了
// pub enum Msg {
//     TestClick,
//     LoadUser,
//     LoadUserDone(Option<String>)
   
// }
// 组件对象
pub struct TestComp{
    name:String
}
use crate::apis::test::*; 
use serde::{Deserialize, Serialize};
#[derive(Clone, PartialEq, Deserialize,Serialize)]
struct User {  // 业务 类（struct)
  name:String 
}
impl UserTrait for User  {
    fn get_name(self)->String {
        return self.name;
    }
}

// 移走了
// 获取用户信息的 异步函数
//  async fn get_user()->Result<String,wasm_bindgen::JsValue>{
//   let user:User=Request::get("http://localhost:8081/test").send().
//   await.unwrap().json().await.unwrap();
//   Ok(user.name.to_string())
//  }
 //本课程来自 程序员在囧途(www.jtthink.com) 咨询群：98514334

 
impl Component for TestComp{
      type Message =  TestMsg;
      type Properties = ();
    fn create(ctx: &Context<Self>) -> Self{
    
       ctx.link().send_message(TestMsg::LoadUser); //触发加载用户
       //本课程来自 程序员在囧途(www.jtthink.com) 咨询群：98514334
        Self { name: String::from("初始值") }
      }
    fn update(&mut self, ctx: &Context<Self>, msg: Self::Message) -> bool {
        match msg{
          TestMsg::TestClick=>{
              js::alert("按钮点击");
            true
          }
          TestMsg::LoadUser=>{
            // 移走了
            // let f=async {
            //     match get_user::<User>().await{
            //         Ok(u)=> TestMsg::LoadUserDone(Some(u.name)),
            //         Err(_)=>TestMsg::LoadUserDone(Some("nouser".to_string()))
            //     }
            // };
            ctx.link().send_future(get_user_future::<User>());
            true 
          }
          TestMsg::LoadUserDone(data)=>{
              self.name=data;
            true
          }
           
        } 
    
    }
    fn view(&self, ctx: &Context<Self>) -> Html{
        html!{
            <div>
            <button onclick={ctx.link().callback(|_| TestMsg::TestClick )}>{"点我"}</button>
              <h1>{&self.name}</h1>      
            </div>
        }
    }

}