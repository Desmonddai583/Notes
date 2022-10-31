extern crate wasm_bindgen;
use yew::prelude::*;
use yew::{html, Component, Html};

use crate::utils::*;
use crate::models::*;

use crate::elements::ElInput;
use crate::elements::ElSelect;

pub struct ProdNew {
    prod_name: String,
    areas:Vec<ValueText>
}


pub enum Msg {
    InputChange(String),
    SetAreas(Option<String>),
    Message(Option<String>),
}

impl Component for ProdNew {
    type Message = Msg;
    type Properties = ();

    fn create(_ctx: &Context<Self>) -> Self {
        ProdNew {
            prod_name: String::new(),
            areas:Vec::new(),
        }
       
    }
    fn rendered(&mut self, ctx: &Context<Self>, first_render: bool) {
        if first_render {
            let f= async {
                match get("http://192.168.29.1:8080/").await{
                    Ok(s)=>Msg::SetAreas(Some(s)),
                    Err(e)=>Msg::Message(e.as_string()) 
                }
            };
            send(ctx.link().clone(), f);
        }
    }
    fn update(&mut self, _ctx: &Context<Self>, msg: Self::Message) -> bool {
        match msg {
            Msg::InputChange(value) => {
                self.prod_name = value;
            },
            Msg::SetAreas(s) =>{
                if let Some(area_str)=s{
                   // alert(area_str.as_str());
                     self.areas=serde_json::from_str(&area_str).unwrap()
                }
            },
            Msg::Message(s) =>{
                if let Some(str)=s{
                    alert(str.as_str());
                }
            },
        };
        true
    }
    fn view(&self, ctx: &Context<Self>) -> Html {
        html! {
            <div id="app" >
              <div class="line">
                <ElInput maxlen=20
                 onchange={ctx.link().callback(Msg::InputChange)}
                 placeholder="input product name"  />
              </div>
              <div>
                <ElSelect data={self.areas.clone()} />
              </div>
            </div>
        }
    }
}
 