extern crate wasm_bindgen;
use serde::{Deserialize, Serialize};

use wasm_bindgen::{closure::Closure, prelude::wasm_bindgen, JsValue};
use yew::prelude::*;
use yew::{html, Component, Html};
#[wasm_bindgen]
extern "C" {
    #[wasm_bindgen(js_namespace=console)]
    fn log(s: &str);
    #[wasm_bindgen(js_name = "get_data")]
    fn get_data(callback: JsValue);
  
}
fn get_user_by_js(callback: Callback<String>) {
    let callback = Closure::once_into_js(move |param: String| callback.emit(param));
    get_data(callback);
}

#[derive(Debug, Serialize, Deserialize)]
struct UserModel {
    userid: i32,
    username: String,
}
// fn get_user() -> UserModel {
//     let v: UserModel = serde_json::from_str(get_data().as_str()).unwrap();
//     v
// }

pub struct App2 {
    users: Vec<UserModel>
}
pub enum Msg {
    GetUser,
    SetUser(String)
}

impl Component for App2 {
    type Message = Msg;
    type Properties = ();
    fn create(_ctx: &Context<Self>) -> Self {
        App2 {
            users: Vec::new()
        }
    }
    fn rendered(&mut self, ctx: &Context<Self>, first_render: bool) {
       if first_render{
           get_user_by_js(ctx.link().callback(Msg::SetUser));
       }
    }
    fn update(&mut self, ctx: &Context<Self>, msg: Self::Message) -> bool {
        match msg {
            Msg::SetUser(s)=>{
                self.users = serde_json::from_str(s.as_str()).unwrap();  
            }
            Msg::GetUser=>{
                get_user_by_js(ctx.link().callback(Msg::SetUser));
            }
        };
        true
    }
    fn view(&self, _ctx: &Context<Self>) -> Html {
        html! {
            <div id="app" >
            <ul>
             {for self.users.iter().map(|u:&UserModel| self.show_user(u) )}
            </ul>
                <p>
                {self.test()}
                </p>
            </div>

        }
    }
}
impl App2 {
    fn test(&self) -> Html {
        html! {
            {"abc"}
        }
    }
    fn show_user(&self,u:&UserModel)->Html{
        html! {
            <li>{u.userid} {u.username.as_str()} </li>
        }
    }
    
}
