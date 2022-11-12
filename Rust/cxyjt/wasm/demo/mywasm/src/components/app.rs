extern crate wasm_bindgen;
use wasm_bindgen::prelude::*;
use web_sys::HtmlInputElement;
use yew::prelude::*;

#[wasm_bindgen]
extern "C" {
    fn alert(s: &str);
}

pub struct App {
    user_name: String,
    user_pass: String,
}
pub enum Msg {
    BtnClick,
    SetInput(InputEvent, u8),
}
impl Component for App {
    type Message = Msg;
    type Properties = ();
    fn create(_ctx: &Context<Self>) -> Self {
        App {
            user_name: "".to_string(),
            user_pass: "".to_string(),
        }
    }
    fn update(&mut self, _ctx: &Context<Self>, msg: Self::Message) -> bool {
        match msg {
            Msg::BtnClick => {
                alert(format!("username:{},userpass:{}", self.user_name, self.user_pass).as_str());
            }
            Msg::SetInput(e, t) => {
                if t == 1 {
                    let input: HtmlInputElement = e.target_unchecked_into();
                    self.user_name = input.value();
                } else {
                  let input: HtmlInputElement = e.target_unchecked_into();
                    self.user_pass = input.value();
                }
            }
        }
        true
    }
    fn view(&self, ctx: &Context<Self>) -> Html {
        html! {
            <div id="app">
               <div><span>{"Username:"}</span>
             <input    type="text" oninput={ctx.link().callback(|e:InputEvent| Msg::SetInput(e,1))}/>
               </div>
               <div><span>{"Password:"}</span>
                  <input   type="text" oninput={ctx.link().callback(|e:InputEvent| Msg::SetInput(e,2))}  />
               </div>
               <div>
                  <button onclick={ctx.link().callback(|_| Msg::BtnClick )}>{ "button" }</button>
               </div>
                <div>
                   <p>{"username:"}{self.user_name.as_str()}</p>
                   <p>{"userpass:"}{self.user_pass.as_str()}</p>
                </div>
            </div>
        }
    }
}
