extern crate wasm_bindgen;
use crate::models::ValueText;
use yew::prelude::*;
use yew::{html, Component, Html};

pub struct ElSelect {
    show: bool,
    value:String,
    text:String
}
pub enum Msg {
    Toggle(),
    Set(String,String),
}
#[derive(Clone, PartialEq, Properties)]
pub struct Props {
    // #[prop_or(vec!((String::from(""),String::from("--select--"))))]
    // pub data: Vec<ValueText>,
    #[prop_or(vec!(ValueText{value:String::from(""),text:String::from("---select---")}))]
    pub data: Vec<ValueText>,
}

impl Component for ElSelect {
    type Message = Msg;
    type Properties = Props;
    fn create(_ctx: &Context<Self>) -> Self {
        ElSelect {
            show: false,
            value:String::new(),
            text:String::new()
        }
    }
    fn rendered(&mut self, _ctx: &Context<Self>, first_render: bool) {
        if first_render {
            
        }  
    }
    fn update(&mut self, _ctx: &Context<Self>, msg: Self::Message) -> bool {
        match msg {
            Msg::Toggle() => {
                self.show = !self.show;
            },
            Msg::Set(v,t)=>{
              self.value=v;
              self.text=t;
              self.show = !self.show;
            }
        };
        true
    }

    fn view(&self, ctx: &Context<Self>) -> Html {
        html! {
            <div class="el-select">
             <div class="el-input el-input--suffix ">
             <input type="text" readonly=true autocomplete="off"
              placeholder="请选择"
              onclick={ctx.link().callback(|_| Msg::Toggle())}
              value={self.text.to_string()}
              class="el-input__inner"/>
                <span class="el-input__suffix">
                    <span class="el-input__suffix-inner">
                    <i class={format!("el-select__caret
                        el-input__icon
                         ")+{
                             if self.show{
                                 "el-icon-arrow-down"
                             }else{
                                 "el-icon-arrow-up"
                             }
                         }}
                    ></i>
                    </span>
                </span>
              </div>


            <div class="el-scrollbar el-popper el-select-dropdown "
            style={format!("position: absolute !important;
            left:0; top:35px;z-index: 2000;width:100%;")+{
                 if self.show{
                     ""
                 }else{
                     "display:none"
                 }
            }}>
              <div class="el-select-dropdown__wrap"  >
                    <ul class="el-scrollbar__view el-select-dropdown__list">
                    {
                        for ctx.props().data.iter().map(|vt|{
                            let v=format!("{}",&vt.value);
                            let t=format!("{}",&vt.text);
                            html!{
                                <li onclick={ctx.link().callback(move |_| Msg::Set(v.clone(),t.clone()))} class="el-select-dropdown__item">
                                    <span>{vt.text.as_str()}</span>
                                </li>

                            }
                        })
                    }

                    </ul>
             </div>
            </div>


            </div>

        }
    }
}
