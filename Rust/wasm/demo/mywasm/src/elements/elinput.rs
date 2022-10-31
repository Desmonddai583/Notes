extern crate wasm_bindgen;

use yew::prelude::*;
use yew::{html, Component, Html};
use web_sys::HtmlInputElement;
use crate::elements::MaxLen;

pub struct ElInput {
    text: String,
}
pub enum Msg {
    Edit(InputEvent),
}
#[derive(Clone, PartialEq, Properties)]
pub struct Props {
    #[prop_or(false)]
    pub disabled: bool,
    #[prop_or(String::from("input sth..."))]
    pub placeholder: String,
    #[prop_or(0)]
    pub maxlen: i32,

    pub onchange: Callback<String>,

    #[prop_or_default]
    pub regx: String,
}

impl Component for ElInput {
    type Message = Msg;
    type Properties = Props;
    fn create(_ctx: &Context<Self>) -> Self {
        ElInput {
            text: String::new(),
        }
    }
    fn rendered(&mut self, _ctx: &Context<Self>, first_render: bool) {
        if first_render {}
    }
    fn update(&mut self, ctx: &Context<Self>, msg: Self::Message) -> bool {
        match msg {
            Msg::Edit(e) => {
                let input: HtmlInputElement = e.target_unchecked_into();
                if ctx.props().maxlen > 0 && self.text.len() as i32 >= ctx.props().maxlen {
                    self.text = input.value()
                        .chars()
                        .skip(0)
                        .take(ctx.props().maxlen as usize)
                        .collect();
                } else {
                    self.text = input.value();
                }
                ctx.props().onchange.emit(self.text.to_string());
            }
        };
        true
    }
    fn view(&self, ctx: &Context<Self>) -> Html {
        html! {
            <div class={self.load_class(ctx)}>
                  <input disabled={ctx.props().disabled}
                  value={self.text.to_string()}
                   class="el-input__inner"
                    oninput={ctx.link().callback(|e:InputEvent| Msg::Edit(e))}
                    placeholder={ctx.props().placeholder.to_string()}/>
                    <MaxLen
                       maxlen={ctx.props().maxlen}
                       len={self.text.len() as i32}/>
             </div>

        }
    }
}
impl ElInput {
    fn load_class(&self, ctx: &Context<Self>) -> String {
        let mut class = String::from("el-input");
        if ctx.props().disabled {
            class.push_str(" is-disabled")
        }
        class
    }
}
