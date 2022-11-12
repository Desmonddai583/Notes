extern crate wasm_bindgen;
 
use yew::prelude::*;
use yew::{html, Component, Html};

pub struct MaxLen {
}
pub enum Msg {
}
#[derive(Clone, PartialEq, Properties)]
pub struct Props {
   
    #[prop_or(0)]
    pub maxlen:i32,

    #[prop_or(0)]
    pub len:i32,    //current text len 
   
}

impl Component for MaxLen {
    type Message = Msg;
    type Properties = Props;
    fn create(_ctx: &Context<Self>) -> Self {
        MaxLen {
        }
    }
    fn rendered(&mut self, _ctx: &Context<Self>, first_render: bool) {
       if first_render{

        }
    }
    fn update(&mut self, _ctx: &Context<Self>, _msg: Self::Message) -> bool {
        true
    }
    fn view(&self, ctx: &Context<Self>) -> Html {
        html! {
            <div>
                    {
                        if ctx.props().maxlen>0{
                            html!{
                                <span class="el-input__suffix">
                                <span class="el-input__suffix-inner">
                                 <span class="el-input__count">
                                    <span class="el-input__count-inner">
                                    {{ctx.props().len}}{{"/"}}{{ctx.props().maxlen}}
                                    </span>
                                 </span>
                                </span>
                               </span>
                            }
                        }else{
                            html!{}
                        }
                    }

             </div>

        }
    }
}
 

 
