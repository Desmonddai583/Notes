use wasm_bindgen::prelude::*;
// use web_sys::{Request, RequestInit, RequestMode, Response,Window};
// use wasm_bindgen_futures::JsFuture;
use yew::{Component};
use std::future::Future;
use wasm_bindgen_futures::spawn_local;
// use crate::wasm_bindgen::JsCast;
use yew::html::Scope;
use crate::models::ValueText;
 
pub async fn get(_url:&str)-> Result<String, JsValue>{
    // let mut opts = RequestInit::new();
    // opts.method("GET");
    // opts.mode(RequestMode::Cors);

    // let request = Request::new_with_str_and_init(&url, &opts)?;
    // let window: Window = web_sys::window().unwrap();
    //  let resp_value = JsFuture::from(window.fetch_with_request(&request)).await?;
    //  let resp: Response = resp_value.dyn_into().unwrap();
    // let text = JsFuture::from(resp.text()?).await?;
    let locations = vec!(
      ValueText{value: "sh".to_string(), text: "上海".to_string()},
      ValueText{value: "gz".to_string(), text: "广州".to_string()},
      ValueText{value: "fj".to_string(), text: "福建".to_string()},
    );
    let text = serde_json::to_string(&locations).unwrap();
    Ok(text.to_string())
}

pub fn send<COMP: Component, F>(link: Scope<COMP>, future: F)
where
    F: Future<Output = COMP::Message> + 'static,
{
    spawn_local(async move {
        link.send_message(future.await);
    });
}