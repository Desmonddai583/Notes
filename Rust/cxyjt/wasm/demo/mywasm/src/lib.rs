#![recursion_limit="256"]
extern crate wasm_bindgen;
use wasm_bindgen::prelude::*;

// #[wasm_bindgen]
// extern "C" {
//     //console.log(xxxx)
//     #[wasm_bindgen(js_namespace=console)]
//     fn log(s: &str);
// }
// macro_rules! echo {
//     ($expr:expr) => {
//         log(format!("{}", $expr).as_str());
//     };
// }

// #[wasm_bindgen]
// pub fn echo(s: &str) {
//     echo!(s);
// }
// mod models;

// #[wasm_bindgen(start)]
// pub fn run() ->Result<(),JsValue>   {
//     let window = web_sys::window().expect("no window");
//     let document = window.document().expect("no document");
//     let body = document.body().expect("no body");
 
//     let val = document.create_element("button")?;
//     val.set_inner_html("click me");

//     body.append_child(&val)?;
//     Ok(())
// }

mod elements;
mod utils;
mod models;
mod components;
// use components::App;
// use components::App2;
// use components::ProdList;
use components::ProdNew;

#[wasm_bindgen(start)]
pub fn run() -> Result<(), JsValue> {
    yew::start_app::<ProdNew>();
    Ok(())
}
