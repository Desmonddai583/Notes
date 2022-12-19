 
use web_sys::Document;
use web_sys::window;
use web_sys::console;
use wasm_bindgen::prelude::*;
use wasm_bindgen::JsCast;
use wasm_bindgen::JsValue;
//本课程来自 程序员在囧途(www.jtthink.com) 咨询群：98514334
// window.alert 
pub fn alert(str:&str){
   window().unwrap().alert_with_message(str).unwrap();
} 
 
//本课程来自 程序员在囧途(www.jtthink.com) 咨询群：98514334
pub fn log(obj:&wasm_bindgen::JsValue){
   #[allow(unused_unsafe)]
   unsafe{
      console::log_1(obj);
   }
}
pub fn log_str(str:&str){
   log(&wasm_bindgen::JsValue::from_str(str));
}
pub fn get_document()->Result<Document,JsValue>{
    let window = web_sys::window().expect("error window");
   
    let document = window.document().expect("error document");
    Ok(document)
}
// getElementById 
pub fn get_by_id(id:&str)->Result<web_sys::HtmlElement, JsValue>{
    let document = get_document().unwrap(); 
    let ele=document.get_element_by_id(id).
       expect("cann't found element").dyn_into::<web_sys::HtmlElement>().expect("error element");
    Ok(ele)
}
// 从window里获取全局对象
pub fn get_window_object(name:&str)->Option<js_sys::Object>{
   let window = web_sys::window().expect("error window");
   window.get(name)
}
 